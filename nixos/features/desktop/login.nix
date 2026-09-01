{
  flake.nixosModules.login = {
    pkgs,
    config,
    ...
  }: {
    services.greetd = {
      enable = true;
      # Whether the greeter uses text-based user interfaces (For example, tuigreet).
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
        };
      };
    };

    systemd.user.services.polkit-mate-authentication-agent-1 = {
      description = "PolicyKit Authentication Agent for the MATE Desktop";

      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
        Slice = "session.slice";
        TimeoutStopSec = "5sec";
        Restart = "on-failure";
      };
    };
  };
}
