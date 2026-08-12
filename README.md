# nixos-config

Flake-parts configuration for two hosts, `laptop` and `desktop`. All `.nix`
files outside `flake.nix` are imported recursively, so a new module under
`nixos/features` only needs adding to the imports list in
`nixos/hosts/shared.nix`.

```
nixos-rebuild switch --flake .#laptop
```

## Full disk encryption

Both hosts store the root filesystem on an encrypted LUKS2 volume, and both use
Secure Boot through lanzaboote. The passphrase is enrolled in key slot 0 and is
never removed; every other slot is an additional way of obtaining the same
master key, not a replacement for it.

By default a LUKS volume can only be opened by typing its passphrase, which
means one prompt in the initrd and a second prompt at the display manager for
the login keyring. To avoid entering a password twice per boot, each volume also
carries a TPM2 key slot bound to PCR 7. The initrd unseals that slot without
interaction, and the only password typed during boot is the one at the greeter,
which also unlocks the GNOME keyring.

### Enrolling the TPM

Enrollment writes to the LUKS header and is therefore a manual step, performed
once per volume on the machine itself. It is not expressed in this flake. Run
it from a normal terminal, as it needs direct access to the block device:

```ShellSession
$ sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
```

On `laptop` there is a single encrypted volume. On `desktop` there are three,
and each must be enrolled separately or the initrd will still prompt for the
volumes that were missed:

```ShellSession
$ sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
    /dev/disk/by-uuid/39a89e32-c890-4ff9-842e-34c16a497231
$ sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
    /dev/disk/by-uuid/d57a23be-cf31-405e-ac09-9cb06e6331c1
$ sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
    /dev/disk/by-uuid/5a37508d-66a3-40ba-a228-cdeb5606e521
```

To confirm that a volume is enrolled, look for a `systemd-tpm2` token in its
header. The token names the key slot it unseals:

```ShellSession
$ sudo cryptsetup luksDump /dev/nvme0n1p2
```

### When enrollment must be repeated

PCR 7 records the Secure Boot policy in effect when the machine started. Any
change to that policy produces a different PCR value, the TPM refuses to
release the key, and the initrd falls back to prompting for the passphrase in
slot 0. This is expected after enrolling new Secure Boot keys with `sbctl`,
after a firmware update that reseeds the key databases, and after disabling or
re-enabling Secure Boot.

Booting a different kernel or a new system generation does not affect PCR 7, so
ordinary updates require no action.

Recovery is to boot with the passphrase and enroll again. Adding a second TPM2
slot to a volume that already has one requires removing the stale slot first:

```ShellSession
$ sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
```

Because PCR 7 covers the Secure Boot policy rather than the booted image, any
binary signed by a trusted key can unseal the volume. This protects a powered
off machine against disk theft. It does not by itself prevent an attacker who
can boot another signed image on the same hardware.

## Login and the keyring

`nixos/features/login.nix` owns the greeter and the keyring. greetd runs
tuigreet on tty1, and its PAM stack includes `login`, which is where
`pam_gnome_keyring` picks up the typed password and unlocks the login keyring.

The fingerprint reader is deliberately not part of that stack.
`pam_fprintd` is `sufficient` and is ordered ahead of `pam_gnome_keyring`, so a
matched fingerprint would satisfy authentication before the keyring module ever
ran, and the session would start with the keyring still locked. Fingerprint
authentication remains enabled for `sudo`, for `polkit`, and for the noctalia
lock screen, which authenticates against its own PAM service rather than
against `login`.

The keyring password must match the account password. It is set once through
Seahorse, or by deleting `~/.local/share/keyrings/login.keyring` and logging in
again.
