{
  flake.nixosModules.security = {...}: {
    security.apparmor.enable = true;
    security.polkit.enable = true;
  };
}
