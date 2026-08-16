{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: let
    ignores = pkgs.writeText "gitignore" ''
      .envrc
      .direnv/
    '';
  in {
    # Git configuration settings.
    # See git-config(1) for available options.
    packages.git =
      (inputs.wrappers.wrapperModules.git.apply {
        inherit pkgs;
        settings = {
          user = {
            name = self.fullName;
            email = "65299214+samuel-garmany@users.noreply.github.com";
          };
          init.defaultBranch = "main";
          core.excludesFile = toString ignores;
        };
      }).wrapper;
  };

  flake.nixosModules.git = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
    ];
  };
}
