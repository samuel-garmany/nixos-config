{
  flake.nixosModules.fabrication = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      freecad
      orca-slicer
    ];
  };
}
