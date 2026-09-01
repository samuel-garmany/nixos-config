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
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
    };

    security.pam.services.login.fprintAuth = false;
    security.pam.services.noctalia = {};

    # Note that to start plasma-polkit-agent with systemd on Fedora, you'll need
    # to override its systemd service to add the correct dependency.
    # https://github.com/YaLTeR/niri/wiki/Important-Software
    environment.systemPackages = [pkgs.kdePackages.polkit-kde-agent-1];
    systemd.user.services.plasma-polkit-agent = {
      # Defines how unit configuration is provided for systemd: asDropin creates
      # a drop-in file named overrides.conf.
      overrideStrategy = "asDropin";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
    };
  };
}
