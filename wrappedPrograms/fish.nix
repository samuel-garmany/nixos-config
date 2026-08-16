{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    fishConf =
      pkgs.writeText "config.fish"
      # fish
      ''
        set -g fish_greeting

        ${lib.getExe pkgs.starship} init fish | source
        ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
        ${lib.getExe pkgs.fzf} --fish | source

        alias cat ${lib.getExe pkgs.bat}
        alias ls ${lib.getExe pkgs.eza}
        alias ll '${lib.getExe pkgs.eza} -l'
        alias la '${lib.getExe pkgs.eza} -la'

        # Shell wrapper that provides the ability to change the current working
        # directory when exiting Yazi.
        # https://yazi-rs.github.io/docs/quick-start
        function y
        	set tmp (mktemp -t "yazi-cwd.XXXXXX")
        	command yazi $argv --cwd-file="$tmp"
        	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        		builtin cd -- "$cwd"
        	end
        	command rm -f -- "$tmp"
        end
      '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };

  flake.nixosModules.fish = {
    pkgs,
    lib,
    ...
  }: let
    shell = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
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
