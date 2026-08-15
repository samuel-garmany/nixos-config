{
  flake.nixosModules.hardware = {...}: {
    zramSwap.enable = true;
    systemd.oomd.enable = true;
    services.fwupd.enable = true;
    services.fprintd.enable = true;
  };
}
