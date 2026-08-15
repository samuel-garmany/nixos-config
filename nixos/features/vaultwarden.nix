{
  flake.nixosModules.vaultwarden = {...}: {
    services.vaultwarden = {
      enable = true;
      domain = "vault.garmany.me";

      config = {
        # Controls if new users can register
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8081;
      };
    };
  };
}
