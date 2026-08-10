{
  flake.nixosModules.arduino = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.arduino-ide
    ];
  };
}
