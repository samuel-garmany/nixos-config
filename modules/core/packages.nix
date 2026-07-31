{
  config.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      arduino-ide
      audacity
      anydesk
      blanket
      freecad
      freetube
      gimp
      hunspell
      hunspellDicts.en_US
      hyphenDicts.en_US
      inkscape
      jre8
      libreoffice
      ltex-ls
      obs-studio
      orca-slicer
      poppler-utils
      # qgis # Currently failing to build on unstable (python3-qscintilla-qt6 issue)
      slack
      texliveFull
      unzip
      veracrypt
      vorta
      yubioath-flutter
      zoom-us
    ];
  };

  config.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      discord
      faugus-launcher
      prismlauncher
    ];
  };
}
