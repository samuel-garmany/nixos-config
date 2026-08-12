{
  flake.nixosModules.nextcloud = {pkgs, ...}: {
    environment.systemPackages = [pkgs.nextcloud-client];
  };
}
