{
  flake.nixosModules.nautilus = {pkgs, ...}: {
    xdg.mime.defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };

    environment.systemPackages = [
      pkgs.nautilus
    ];

    # Trash, network shares and removable media for GTK file managers
    services.gvfs.enable = true;
  };
}
