{self, ...}: {
  flake.nixosModules.fish = {
    pkgs,
    lib,
    ...
  }: {
    # Whether to configure fish as an interactive shell.
    # To enable vendor fish completions provided by Nixpkgs you will also want
    # to enable the fish shell.
    programs.fish.enable = true;

    programs.fish.shellAliases = {
      cat = lib.getExe pkgs.bat;
      ls = lib.getExe pkgs.eza;
      ll = "${lib.getExe pkgs.eza} -l";
      la = "${lib.getExe pkgs.eza} -la";
    };

    # Shell script code called during interactive fish shell initialisation.
    programs.fish.interactiveShellInit = ''
      set -g fish_greeting

      ${lib.getExe pkgs.starship} init fish | source
      ${lib.getExe pkgs.zoxide} init --cmd cd fish | source
      ${lib.getExe pkgs.fzf} --fish | source

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

    # The path to the user's shell.
    # Using fish as your login shell (via /etc/passwd) may cause issues,
    # particularly for the root user, because fish is not POSIX compliant.
    users.users.${self.username}.shell = pkgs.fish;

    # A list of permissible login shells for user accounts.
    environment.shells = [pkgs.fish];
  };
}
