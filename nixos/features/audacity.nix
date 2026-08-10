{
  flake.nixosModules.audacity = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.audacity
    ];
  };
}
