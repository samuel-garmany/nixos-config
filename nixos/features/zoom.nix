{
  flake.nixosModules.zoom = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.zoom-us
    ];
  };
}
