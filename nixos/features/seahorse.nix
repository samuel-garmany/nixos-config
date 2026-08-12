{
  flake.nixosModules.seahorse = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.seahorse
    ];
  };
}
