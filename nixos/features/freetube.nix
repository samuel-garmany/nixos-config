{
  flake.nixosModules.freetube = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.freetube
    ];
  };
}
