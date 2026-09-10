{self, ...}: {
  flake.nixosModules.vaultwarden = {config, ...}: {
    # /mnt/data is nofail, so the units have to wait for the mounts themselves.
    systemd.services.vaultwarden.unitConfig.RequiresMountsFor = "/var/lib/vaultwarden";
    systemd.services.backup-vaultwarden.unitConfig.RequiresMountsFor =
      config.services.vaultwarden.backupDir;

    services.vaultwarden = {
      enable = true;
      domain = self.vaultDomain;

      # The directory under which vaultwarden will backup its persistent data.
      backupDir = "/mnt/data/backups/vaultwarden";

      config = {
        # Controls if new users can register
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8081;
      };
    };
  };
}
