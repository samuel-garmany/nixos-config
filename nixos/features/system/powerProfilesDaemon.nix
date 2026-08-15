{
  flake.nixosModules.powerProfilesDaemon = {...}: {
    services.power-profiles-daemon.enable = true;
  };
}
