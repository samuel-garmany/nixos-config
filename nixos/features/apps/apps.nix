{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      anki
      anydesk
      audacity
      baobab
      blanket
      foliate
      file-roller
      freetube
      gimp
      gnome-disk-utility
      gnome-text-editor
      gocryptfs
      inkscape
      loupe
      manix
      mpv
      nix-inspect
      pika-backup
      qalculate-gtk
      qgis
      resources
      satty
      slack
      snapshot
      veracrypt
      zoom-us
    ];
  };
}
