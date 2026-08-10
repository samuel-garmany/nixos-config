{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    # My primary flake shell with all of it's packages
    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # sourced by config.fish
        pkgs.bat
        pkgs.eza
        pkgs.fzf
        pkgs.starship
        pkgs.zoxide
        pkgs.yazi

        # wrapped
        pkgs.btop
        self'.packages.git

        pkgs.fd
        pkgs.ripgrep
        pkgs.jq
        pkgs.tldr
        pkgs.gh
        pkgs.lazygit
        pkgs.unzip
      ];
    };
  };
}
