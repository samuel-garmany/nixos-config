{self, ...}: {
  flake.nixosModules.vaultwarden = {
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
