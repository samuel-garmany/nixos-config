{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        audacity
        cine
        freecad
        freetube
        gimp
        inkscape
        obs-studio
        orca-slicer
        qgis
      ];
    };
}
