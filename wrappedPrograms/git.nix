{self, ...}: {
  flake.wrappers.git = {
    pkgs,
    wlib,
    ...
  }: let
    ignores = pkgs.writeText "gitignore" ''
      .envrc
      .direnv/
    '';
  in {
    imports = [wlib.wrapperModules.git];

    # Git configuration settings.
    # See git-config(1) for available options.
    settings = {
      user = {
        name = self.fullName;
        email = "65299214+samuel-garmany@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      core.excludesFile = toString ignores;
    };
  };

  flake.nixosModules.git = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
    ];
  };
}
