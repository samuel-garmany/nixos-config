# nixos-config

This flake defines my NixOS systems. It tries to replicate the dendritic pattern
and uses niri and noctalia for the desktop. Below is also where I document any
imperative steps needed to replicate this configuration.

```
nixos-rebuild switch --flake .#<hostname>
```

## TPM

List the encrypted volumes:

```
lsblk -o NAME,FSTYPE,UUID
```

Enroll every `crypto_LUKS` device once, per machine:

```
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/<uuid>
```

Check for a `systemd-tpm2` token:

```
sudo cryptsetup luksDump /dev/disk/by-uuid/<uuid>
```

PCR 7 changes when Secure Boot keys or firmware change; the passphrase in slot 0
still works. Re-enroll with:

```
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/<uuid>
```

## Keyring

greetd unlocks the login keyring with the account password. If the two ever
diverge, GNOME Keyring prompts separately after login; delete
`~/.local/share/keyrings/login.keyring` and log in again to reset it.

## Long-running jobs

swayidle suspends the machine after 30 idle minutes. Run anything that has to
outlive that under an inhibitor:

```
systemd-inhibit --what=idle:sleep --why="<reason>" <command>
```
