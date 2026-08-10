{inputs, ...}: {
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
        ${lib.getExe pkgs.direnv} hook fish | source

        alias cat ${lib.getExe pkgs.bat}
        alias ls ${lib.getExe pkgs.eza}
        alias ll '${lib.getExe pkgs.eza} -l'
        alias la '${lib.getExe pkgs.eza} -la'

        # Shell wrapper that provides the ability to change the current working
        # directory when exiting Yazi.
        # https://yazi-rs.github.io/docs/quick-start
        function y
        	set tmp (mktemp -t "yazi-cwd.XXXXXX")
        	yazi $argv --cwd-file="$tmp"
        	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        		builtin cd -- "$cwd"
        	end
        	rm -f -- "$tmp"
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
}
