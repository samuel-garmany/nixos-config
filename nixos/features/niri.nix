{self, ...}: {
  flake.nixosModules.niri = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

    environment.systemPackages = [
      selfpkgs.terminal
      selfpkgs.noctalia-shell
      pkgs.xwayland-satellite
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.pwvucontrol
      pkgs.wl-mirror
      pkgs.jq
      pkgs.xdg-terminal-exec
    ];

    # Terminal=true entries go to the first known_terminals hit on PATH, which
    # alacritty is not in and xdg-terminal-exec heads.
    # gio/gdesktopappinfo.c, prepend_terminal_to_vector
    #
    # Preferred terminals are configured by listing them in config files named
    # xdg-terminals.list placed in XDG Config hierarchy.
    # xdg-terminal-exec(1)
    environment.etc."xdg/xdg-terminals.list".text = ''
      Alacritty.desktop
    '';

    # Restarted on failure so the lock screen, which idle.nix reaches over IPC,
    # cannot go missing for the rest of the session.
    systemd.user.services.noctalia-shell = {
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];

      # "Whether to append a minimal default PATH environment variable to the
      # service, containing common system utilities."
      # systemd.user.services.<name>.enableDefaultPath
      enableDefaultPath = false;

      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${selfpkgs.noctalia-shell}/bin/noctalia-shell";
    };

    services.upower.enable = true;
  };
}
