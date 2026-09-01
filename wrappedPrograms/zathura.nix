{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: let
    # This commands allows one to include other configuration files.
    # zathurarc(5)
    configDir = pkgs.runCommand "zathura-config-dir" {} ''
      mkdir -p $out
      echo 'include /home/${self.username}/.config/zathura/noctaliarc' > $out/zathurarc
    '';
  in {
    packages.zathura = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.zathura;
      # -c, --config-dir=path    Path to the config directory
      flags."--config-dir" = "${configDir}";
    };
  };

  flake.nixosModules.zathura = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.zathura
    ];
  };
}
