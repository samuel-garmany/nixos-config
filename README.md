# nixos-config

```
nixos-rebuild switch --flake .#laptop
```

## TPM

List the encrypted volumes:

```
lsblk -o NAME,FSTYPE,UUID
```

Enroll every `crypto_LUKS` device once, per machine, from a real terminal:

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

The login keyring password must equal the account password. Delete
`~/.local/share/keyrings/login.keyring` and log in again to reset it.
