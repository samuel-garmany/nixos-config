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

    security.pam.services.login.fprintAuth = false;
    security.pam.services.noctalia = {};
    security.pam.services.passwd.enableGnomeKeyring = true;

    # If enabled, pam_gnome_keyring will attempt to automatically unlock the
    # user's default Gnome keyring upon login. If the user login password does
    # not match their keyring password, Gnome Keyring will prompt separately
    # after login.
    # security.pam.services.<name>.enableGnomeKeyring
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
