{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      anki
      anydesk
      audacity
      blanket
      foliate
      file-roller
      freetube
      gimp
      gnome-disk-utility
      gocryptfs
      inkscape
      manix
      mpv
      nix-inspect
      qalculate-gtk
      qgis
      resources
      satty
      slack
      veracrypt
      zoom-us
    ];
  };
}
