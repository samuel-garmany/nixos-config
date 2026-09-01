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

      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    security.pam.services.noctalia = {};
    security.pam.services.passwd.enableGnomeKeyring = true;
  };
}
