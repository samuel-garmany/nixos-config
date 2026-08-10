{
  flake.nixosModules.gnome-weather = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.gnome-weather
    ];
  };
}
