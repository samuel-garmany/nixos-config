{
  flake.nixosModules.vaultwarden = {...}: {
    services.vaultwarden = {
      enable = true;
      domain = "vault.garmany.me";

      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8081;
      };
    };
  };
}
