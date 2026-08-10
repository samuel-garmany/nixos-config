{
  flake.nixosModules.power-profiles-daemon = {...}: {
    services.power-profiles-daemon.enable = true;
  };
}
