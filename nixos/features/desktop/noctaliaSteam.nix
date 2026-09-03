{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.noctaliaSteam = {pkgs, ...}: {
    imports = [
      self.nixosModules.gaming
    ];

    programs.steam.package = inputs.millennium.packages.${pkgs.stdenv.hostPlatform.system}.millennium-steam;
  };
}
