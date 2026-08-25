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
      freecad
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
      orca-slicer
      qalculate-gtk
      qgis
      resources
      satty
      slack
      snapshot
      veracrypt
      vorta
      zoom-us
    ];
  };
}
