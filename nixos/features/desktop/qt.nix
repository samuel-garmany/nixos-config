{
  flake.nixosModules.qt = {
    # nixos/modules/config/qt.nix, qt.platformTheme description:
    #   "gnome: Use GNOME theme, use with `adwaita-qt`"
    qt.enable = true;
    qt.platformTheme = "gnome";
    qt.style = "adwaita";
  };
}
