{
  inputs,
  self,
  ...
}: {
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

  flake.nixosModules.environment = {
    pkgs,
    lib,
    ...
  }: let
    shell = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
  in {
    # The path to the user's shell.
    # Using fish as your login shell (via /etc/passwd) may cause issues,
    # particularly for the root user, because fish is not POSIX compliant.
    users.users.${self.username}.shell = shell;

    # Whether to configure fish as an interactive shell.
    # To enable vendor fish completions provided by Nixpkgs you will also want
    # to enable the fish shell.
    programs.fish.enable = true;

    # A list of permissible login shells for user accounts.
    environment.shells = [shell];
  };
}
