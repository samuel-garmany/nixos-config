{
  flake.nixosModules.qalculate = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.qalculate-gtk
    ];
  };
}
