{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      anki
      anydesk
      audacity
      blanket
      foliate
      freetube
      gimp
      gnome-disk-utility
      gocryptfs
      inkscape
      manix
      mpv
      nix-inspect
      vorta
      qalculate-qt
      qgis
      slack
      zoom-us
    ];
  };
}
