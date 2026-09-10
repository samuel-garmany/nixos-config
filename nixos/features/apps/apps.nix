{
  flake.nixosModules.apps = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    xdg.mime.defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "audio/*" = "io.github.diegopvlk.Cine.desktop";
      "image/*" = "org.gnome.Loupe.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "video/*" = "io.github.diegopvlk.Cine.desktop";
    };

    environment.systemPackages = with pkgs; [
      anki
      anydesk
      audacity
      baobab
      blanket
      cine
      foliate
      file-roller
      freetube
      gimp
      gnome-characters
      gnome-disk-utility
      gnome-text-editor
      gocryptfs
      inkscape
      loupe
      manix
      nix-inspect
      papers
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
