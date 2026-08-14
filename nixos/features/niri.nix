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
    ];

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
