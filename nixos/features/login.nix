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
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.niri.package}/bin/niri-session";
        };
      };
    };

    services.gnome.gnome-keyring.enable = true;

    security.pam.services.login.fprintAuth = false;
    security.pam.services.noctalia = {};
    security.pam.services.passwd.enableGnomeKeyring = true;
  };
}
