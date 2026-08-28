{self, ...}: {
  flake.nixosModules.environment = {pkgs, ...}: {
    imports = [
      self.nixosModules.fish
    ];

    # Desktop entries are stripped in environment.extraSetup, which only runs
    # over the system path, so these live here rather than in the user profile.
    environment.systemPackages = [
      # sourced by config.fish
      pkgs.bat
      pkgs.eza
      pkgs.fzf
      pkgs.starship
      pkgs.zoxide
      pkgs.yazi

      pkgs.btop
      pkgs.fd
      pkgs.ripgrep
      pkgs.jq
      pkgs.tldr
      pkgs.gh
      pkgs.lazygit
    ];
  };
}
