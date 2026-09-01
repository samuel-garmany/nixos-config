{self, ...}: {
  # Idles: waits for idleness and runs a command
  # See swayidle(1)
  flake.nixosModules.idle = {pkgs, ...}: let
    noctalia = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;
    lock = "${noctalia}/bin/noctalia-shell ipc call lockScreen lock";
  in {
    systemd.user.services.swayidle = {
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      # niri.service is Before=graphical-session.target, so ordering after the
      # target is what guarantees WAYLAND_DISPLAY is set by the time this runs
      after = ["graphical-session.target"];

      serviceConfig.Restart = "on-failure";
      serviceConfig.RestartSec = 2;

      serviceConfig.ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
          before-sleep '${lock}'
      '';
    };
  };
}
