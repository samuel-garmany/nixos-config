{
  flake.nixosModules.blanket = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.blanket
    ];
  };
}
