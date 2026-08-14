{
  flake.nixosModules.gtk = {pkgs, ...}: let
    icon-theme-name = "Adwaita";

    gtksettings = ''
      [Settings]
      gtk-icon-theme-name = ${icon-theme-name}
      gtk-cursor-theme-name = ${icon-theme-name}
    '';
  in {
    # nixos/modules/services/desktop-managers/pantheon.nix:
    #   "GTK4 will try both $XDG_CONFIG_DIRS/gtk-4.0 and ${gtk4}/etc/gtk-4.0,
    #    but not /etc/gtk-4.0."
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = gtksettings;
      "xdg/gtk-4.0/settings.ini".text = gtksettings;
    };

    # noctalia's gtk template sets gtk-theme and color-scheme here.
    programs.dconf.profiles.user.databases = [
      {
        lockAll = false;
        settings."org/gnome/desktop/interface".icon-theme = icon-theme-name;
      }
    ];

    environment.systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.adw-gtk3

      # noctalia's gtk template runs `python3 gtk-refresh.py <mode>`
      pkgs.python3
      pkgs.gtk3
      pkgs.gtk4
    ];
  };
}
