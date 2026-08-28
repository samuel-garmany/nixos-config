{self, ...}: {
  flake.nixosModules.environment = {pkgs, ...}: {
    imports = [
      self.nixosModules.fish
    ];

    # The set of packages that should be made available to the user.
    # This is in contrast to environment.systemPackages, which adds packages to
    # all users.
    users.users.${self.username}.packages = [
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
