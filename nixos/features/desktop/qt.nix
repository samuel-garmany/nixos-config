{
  flake.nixosModules.qt = {pkgs, ...}: let
    # Services/Theming/TemplateRegistry.qml in noctalia-shell
    conf = name:
      pkgs.writeText "${name}.conf" ''
        [Appearance]
        standard_dialogs=xdgdesktopportal
        custom_palette=true
        color_scheme_path=$HOME/.config/${name}/colors/noctalia.conf
      '';
  in {
    # Whether to enable Qt configuration, including theming.
    qt.enable = true;

    # qt5ct: Use Qt style set using the qt5ct and qt6ct applications.
    qt.platformTheme = "qt5ct";

    # Create a symlink if it does not exist yet. If suffixed with + and a file
    # or directory already exists where the symlink is to be created, it will be
    # removed and be replaced by the symlink.
    # tmpfiles.d(5)
    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/qt5ct/qt5ct.conf - - - - ${conf "qt5ct"}"
      "L+ %h/.config/qt6ct/qt6ct.conf - - - - ${conf "qt6ct"}"
    ];
  };
}
