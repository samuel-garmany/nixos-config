{
  flake.nixosModules.gocryptfs = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.gocryptfs
    ];
  };
}
