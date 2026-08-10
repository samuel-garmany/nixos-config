{inputs, ...}: {
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
            name = "Samuel Garmany";
            email = "samuel@example.com";
          };
          init.defaultBranch = "main";
          core.excludesFile = toString ignores;
        };
      }).wrapper;
  };
}
