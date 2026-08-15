# nixos-config

One flake for every machine I run: a desktop, a laptop, and a Raspberry Pi that
hosts my files, passwords and DNS. It follows the dendritic pattern, so every file
under `nixos/` is a flake-parts module contributing a `flake.nixosModules.<name>`,
and a host is a list of the ones it wants.

| host | hardware | role |
| --- | --- | --- |
| `desktop` | Intel CPU, AMD GPU | niri, noctalia, Secure Boot via lanzaboote |
| `laptop` | Framework 13 AMD | the same desktop on the road |
| `server` | Raspberry Pi 4B, aarch64 | Nextcloud, Vaultwarden, Calibre-Web, AdGuard Home, cloudflared |

```
nixos-rebuild switch --flake .#<hostname>
nixos-rebuild switch --flake .#server --target-host root@raspberrypi.tail5c3838.ts.net
```

The server is aarch64 and builds on the desktop through
`boot.binfmt.emulatedSystems`. It also pulls the flake from GitHub weekly via
`system.autoUpgrade`, so pushing to `main` deploys it.

```
nixos/base/        values the flake itself reads: username, SSH keys
nixos/features/    one module per concern
nixos/hosts/       configuration.nix + hardware-configuration.nix per machine
wrappedPrograms/   programs whose config is baked into the package, not $HOME
secrets/           sops-encrypted
```

The rest of this file is the part that is not declarative.

## TPM

```
lsblk -o NAME,FSTYPE,UUID

# once per device, per machine
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/<uuid>
sudo cryptsetup luksDump /dev/disk/by-uuid/<uuid>          # want a systemd-tpm2 token
```

A Secure Boot key or firmware change moves PCR 7 and the passphrase prompt comes
back. Slot 0 still works; re-enroll with `--wipe-slot=tpm2` added.

## Keyring

greetd unlocks the login keyring with the account password. If they diverge,
GNOME Keyring prompts separately after login.

```
rm ~/.local/share/keyrings/login.keyring   # then log in again
```

## Noctalia

Settings come from the store; the GUI only changes the running session.

```
noctalia-shell ipc call state all | jq .settings > wrappedPrograms/noctalia/settings.json
```

## Long-running jobs

swayidle suspends after 30 idle minutes.

```
systemd-inhibit --what=idle:sleep --why="<reason>" <command>
```

## Secrets

`secrets/server.yaml` is encrypted to two age recipients in `.sops.yaml`: this
account's SSH key and the server's host key.

```
nix shell nixpkgs#sops nixpkgs#ssh-to-age -c env SOPS_AGE_KEY_CMD="ssh-to-age -private-key -i $HOME/.ssh/id_ed25519" sops <file>
```

`SOPS_AGE_KEY_CMD` is required: sops only probes `~/.ssh/id_rsa`, and its own SSH
support wants `ssh-ed25519` recipients rather than the age ones in `.sops.yaml`.
Only edit through sops — an editor writes plaintext where an
`ENC[AES256_GCM,...]` blob has to be.

## 802.1X Wi-Fi (eduroam, CU Secure)

wpa_supplicant runs with `ProtectHome=true`, so it cannot read the certificates
JoinNow leaves in `~/.joinnow`. `/etc/wpa_supplicant` is in the unit's
`BindPaths=` and the service runs as `wpa_supplicant`.

```
sudo mkdir -p /etc/wpa_supplicant/certs
sudo cp -r ~/.joinnow/* /etc/wpa_supplicant/certs/
sudo chown -R wpa_supplicant:wpa_supplicant /etc/wpa_supplicant/certs
sudo chmod -R 600 /etc/wpa_supplicant/certs
sudo chmod 700 /etc/wpa_supplicant/certs /etc/wpa_supplicant/certs/tls-client-certs

# sudo because nmcli stats the files
sudo nmcli connection modify "<name>" 802-1x.ca-cert "/etc/wpa_supplicant/certs/<ca-bundle>.pem"
# CU Secure also needs 802-1x.client-cert and 802-1x.private-key

# eduroam filters unregistered hardware addresses
nmcli connection modify "eduroam [<uuid>]" 802-11-wireless.cloned-mac-address permanent
```

Survives rebuilds, not reinstalls. SecureW2 certificates expire yearly. To make
this declarative: `networking.networkmanager.ensureProfiles` substitutes
`environmentFiles` into profiles with envsubst, and certificates can come from
`sops.secrets.<name>.path` with `owner = "wpa_supplicant"`.

## Writing the server card

nixos-anywhere needs `CONFIG_KEXEC`, which the Pi kernel lacks. Write a card; it
grows the root partition on first boot. Add the image module to
`nixos/hosts/server/configuration.nix` first — it is not imported normally,
because it drags in `profiles/base.nix`.

```
imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];

nix build .#nixosConfigurations.server.config.system.build.sdImage
zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/<card> bs=4M conv=fsync status=progress
```

Mount the ext4 partition and add the two files that cannot live in the store:

```
/etc/ssh/ssh_host_ed25519_key   600   make it here, so sops can encrypt to it
/root/usb.key                   400   keyfile /etc/crypttab opens /mnt/data with
```

Only that image build writes the FAT partition; `config.txt`, `u-boot.bin` and
`start4.elf` do not change on rebuild.

## Boot order

`0xf41` is SD first, `0xf14` USB first. No `/dev/vcio` on the mainline kernel, so
the boot ROM writes the EEPROM instead of `rpi-eeprom-config --apply`.

```
d=$(nix build --no-link --print-out-paths nixpkgs#raspberrypi-eeprom)/lib/firmware/raspberrypi/bootloader-2711/default
mount /boot/firmware
cp $d/pieeprom-*.bin /boot/firmware/pieeprom.upd
rpi-eeprom-digest -i /boot/firmware/pieeprom.upd -o /boot/firmware/pieeprom.sig
cp $d/recovery.bin /boot/firmware/recovery.bin
reboot
```

`RECOVERY.000` means it flashed; delete the three files. The stock image has no
`BOOT_ORDER` line, which is the `0xf41` default. `rpi-eeprom-config --out` edits
the image for anything else.

## Server storage

`/mnt/data` is the LUKS SSD, `nofail` so the machine boots without it.
`RequiresMountsFor` is what then stops the services starting anyway and letting
Nextcloud reinstall over an empty data directory.

PostgreSQL and Vaultwarden are bind mounted, not moved with each service's own
option: the units are `ProtectSystem=strict` and `StateDirectory=` creates its
directory under `/var/lib` regardless, so `services.postgresql.dataDir` alone
leaves nothing to create the directory `initdb` needs.

```
sudo mkdir -p /mnt/data/postgresql   # bind source must exist
sudo chown root:root /mnt/data       # tmpfiles skips paths under another user
```

Without that chown, systemd-tmpfiles silently skips Nextcloud's
`override.config.php`.

AdGuard stays on the card: `DynamicUser=true` makes `/var/lib/AdGuardHome` a
symlink into `/var/lib/private`, and a bind mount on either path gives
`238/STATE_DIRECTORY`.

## Server state outside the flake

Tailscale's node identity and `serve` mappings are in `/var/lib/tailscale`.

```
sudo systemctl stop tailscaled
sudo tar -xzf var-lib-tailscale.tar.gz -C /var/lib
sudo systemctl start tailscaled
```

```
https://raspberrypi.tail5c3838.ts.net      -> 127.0.0.1:11000  nextcloud
https://raspberrypi.tail5c3838.ts.net:8443 -> 127.0.0.1:3000   adguardhome
https://raspberrypi.tail5c3838.ts.net:8444 -> 127.0.0.1:8081   vaultwarden
https://raspberrypi.tail5c3838.ts.net:8445 -> 127.0.0.1:8083   calibre-web
```

cloudflared publishes `vault.garmany.me`; ingress rules are in the Cloudflare
dashboard.

AdGuard's login, filter lists and per-client settings come from its setup wizard.
Upstream, DNSSEC and log retention are in the flake and merged over the file on
every start. Run the wizard before the first rebuild that ships settings: AdGuard
treats an existing `AdGuardHome.yaml` as installed, and no users means no
authentication.

## Troubleshooting

```
systemctl --failed
systemctl is-system-running          # "starting" forever means a unit is looping
systemctl list-jobs
systemctl show <unit> -p NRestarts   # a looping unit never reaches --failed

systemctl status mnt-data.mount      # SSD did not appear
cryptsetup status luks-4474bb32-41e3-47d1-9de6-f5a6c766228c

dig @100.125.111.58 example.com      # AdGuard is DNS for the whole tailnet
smartctl -a /dev/sda                 # T7 health

journalctl -u cloudflared -b | grep -E "Registered tunnel|Unauthorized"
nextcloud-occ status
nextcloud-occ notify_push:self-test
```

cloudflared over QUIC reports every registration failure as a control stream
error. It falls back to http2 after about thirty seconds and prints the real one.
