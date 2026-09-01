{
  flake.nixosModules.qt = {
    # Whether to enable Qt configuration, including theming.
    qt.enable = true;

    # gnome: Use GNOME theme with qgnomeplatform
    qt.platformTheme = "gnome";

    # adwaita, adwaita-dark, adwaita-highcontrast, adawaita-highcontrastinverse:
    # Use Adwaita Qt style with adwaita
    qt.style = "adwaita-dark";
  };
}
