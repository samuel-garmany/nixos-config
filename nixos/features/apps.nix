{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      anydesk
      arduino-ide
      audacity
      baobab
      blanket
      freecad
      file-roller
      freetube
      gimp
      gnome-disk-utility
      gnome-text-editor
      gocryptfs
      inkscape
      loupe
      mpv
      networkmanagerapplet
      orca-slicer
      qalculate-gtk
      qgis
      resources
      satty
      slack
      veracrypt
      vorta
      zoom-us
    ];
  };
}
