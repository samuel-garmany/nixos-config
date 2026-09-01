{
  flake.nixosModules.gtk = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.adw-gtk3

      # noctalia's gtk template runs `python3 gtk-refresh.py <mode>`
      pkgs.python3
    ];
  };
}
