{
  flake.nixosModules.qt = {pkgs, ...}: let
    # Quoted from Services/Theming/TemplateRegistry.qml in noctalia-shell:
    #   "id": "qt",
    #   "outputs": [
    #     { "path": "~/.config/qt5ct/colors/noctalia.conf" },
    #     { "path": "~/.config/qt6ct/colors/noctalia.conf" }
    #   ]
    # The template writes the colors only; color_scheme_path is the key
    # qt5ct/qt6ct write themselves when a color scheme is picked in their GUI.
    conf = name:
      pkgs.writeText "${name}.conf" ''
        [Appearance]
        standard_dialogs=xdgdesktopportal
        custom_palette=true
        color_scheme_path=$HOME/.config/${name}/colors/noctalia.conf
      '';
  in {
    # nixos/modules/config/qt.nix, qt.platformTheme description:
    #   "qt5ct: Use Qt style set using the qt5ct and qt6ct applications."
    # Selecting it installs both libsForQt5.qt5ct and qt6Packages.qt6ct,
    # which is where noctalia's qt template writes its colors.
    qt.enable = true;
    qt.platformTheme = "qt5ct";

    # tmpfiles.d(5), "L, L+, L?":
    #   "Create a symlink if it does not exist yet. If suffixed with + and a
    #    file or directory already exists where the symlink is to be created,
    #    it will be removed and be replaced by the symlink."
    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/qt5ct/qt5ct.conf - - - - ${conf "qt5ct"}"
      "L+ %h/.config/qt6ct/qt6ct.conf - - - - ${conf "qt6ct"}"
    ];
  };
}
