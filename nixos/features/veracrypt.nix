{
  flake.nixosModules.veracrypt = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.veracrypt
    ];
  };
}
