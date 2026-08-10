{
  flake.nixosModules.vorta = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.vorta
    ];
  };
}
