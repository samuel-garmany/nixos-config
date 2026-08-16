# nixos-config

One flake for every machine I run: a desktop, a laptop, and a Raspberry Pi that
hosts my files, passwords and DNS. It follows the dendritic pattern, so every file
under `nixos/` is a flake-parts module contributing a `flake.nixosModules.<name>`,
and a host is a list of the ones it wants.

| host | hardware | role |
| --- | --- | --- |
| `desktop` | Intel CPU, AMD GPU | niri, noctalia, Secure Boot via lanzaboote |
| `laptop` | Framework 13 AMD | the same desktop trimmed down |
| `server` | Raspberry Pi 4B, aarch64 | Nextcloud, Vaultwarden, Calibre-Web, AdGuard Home, cloudflared |

```
nixos-rebuild switch --flake .#<hostname>
nixos-rebuild switch --flake .#server --target-host root@server.tail5c3838.ts.net
```

The server is aarch64 and builds on the desktop through
`boot.binfmt.emulatedSystems`. It also pulls the flake from GitHub weekly via
`system.autoUpgrade`, so pushing to `main` deploys it.

```
nixos/base/        values the flake itself reads: identity, SSH keys, domains
nixos/features/    one module per concern: system, desktop, apps, services
nixos/profiles/    the feature list for a class of machine
nixos/hosts/       configuration.nix + hardware-configuration.nix per machine
wrappedPrograms/   programs whose config is baked into the package, not $HOME.
                   A program that needs a wrapper is configured here, and its
                   nixosModule lives here too.
secrets/           sops-encrypted
```

The rest of this file is the part that is not declarative.

## tailscale serve

Kept in tailscaled's state, not in the flake.

```
tailscale serve --bg --https=443  8080   # nextcloud
tailscale serve --bg --https=8443 3000   # adguard home
tailscale serve --bg --https=8444 8081   # vaultwarden
tailscale serve --bg --https=8445 8083   # calibre-web

tailscale serve status
```

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

## Polkit agent

mate-polkit is the agent because both machines have fingerprint readers. Switch
to `security.soteria.enable` once soteria does fingerprint auth:
https://github.com/ImVaskel/soteria

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

Survives rebuilds, not reinstalls. SecureW2 certificates expire. Probably could be made declarative with sops but for a temporary keys seemed like a hassle.
