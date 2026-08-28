{self, ...}: {
  flake.nixosModules.terminal = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.terminal
    ];
  };
}
