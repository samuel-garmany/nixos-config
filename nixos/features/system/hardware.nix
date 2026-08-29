{
  flake.nixosModules.hardware = {
    services.fwupd.enable = true;
    services.fprintd.enable = true;
    security.pam.services.login.fprintAuth = false;
  };
}
