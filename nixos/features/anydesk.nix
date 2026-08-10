{
  flake.nixosModules.anydesk = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.anydesk
    ];
  };
}
