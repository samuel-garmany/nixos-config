{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      anydesk
      arduino-ide
      audacity
      blanket
      freecad
      file-roller
      freetube
      gimp
      gocryptfs
      inkscape
      loupe
      mpv
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
