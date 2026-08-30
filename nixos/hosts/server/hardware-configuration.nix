{
  flake.nixosModules.hostServer = {
    lib,
    modulesPath,
    ...
  }: let
    dataUuid = "4474bb32-41e3-47d1-9de6-f5a6c766228c";
    dataMapper = "luks-${dataUuid}";
  in {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # nixos-generate-config finds xhci_pci and uas, but not the mmc stack the
    # card is behind.
    boot.initrd.availableKernelModules = [
      "mmc_block"
      "uas"
      "usbhid"
      "usb_storage"
      "xhci_pci"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    # Only the Raspberry Pi firmware and bootloader. Not needed at runtime.
    fileSystems."/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = ["nofail" "noauto"];
    };

    environment.etc.crypttab.text = ''
      ${dataMapper} UUID=${dataUuid} /root/usb.key luks,nofail
    '';

    fileSystems."/mnt/data" = {
      device = "/dev/mapper/${dataMapper}";
      fsType = "ext4";
      options = ["nofail"];
    };

    # Write-heavy state, bind mounted so the services still see it under
    # /var/lib. See the README.
    fileSystems."/var/lib/postgresql" = {
      device = "/mnt/data/postgresql";
      fsType = "none";
      options = ["bind" "nofail"];
      depends = ["/mnt/data"];
    };

    fileSystems."/var/lib/vaultwarden" = {
      device = "/mnt/data/vaultwarden";
      fsType = "none";
      options = ["bind" "nofail"];
      depends = ["/mnt/data"];
    };

    # Without this, nofail lets these start before the SSD is mounted. See the
    # README. postgresql is absent because its module already sets it.
    systemd.services = {
      borgbackup-repo-borgbackup.unitConfig.RequiresMountsFor = "/mnt/data";
      vaultwarden.unitConfig.RequiresMountsFor = "/var/lib/vaultwarden";
      backup-vaultwarden.unitConfig.RequiresMountsFor = "/mnt/data";
      postgresqlBackup.unitConfig.RequiresMountsFor = "/mnt/data";
      calibre-web.unitConfig.RequiresMountsFor = "/mnt/data";
      nextcloud-cron.unitConfig.RequiresMountsFor = "/mnt/data";
      nextcloud-setup.unitConfig.RequiresMountsFor = "/mnt/data";
      phpfpm-nextcloud.unitConfig.RequiresMountsFor = "/mnt/data";
    };

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  };
}
