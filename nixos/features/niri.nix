{self, ...}: {
  flake.nixosModules.niri = {
    pkgs,
    config,
    ...
  }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.niri.package}/bin/niri-session";
          user = config.preferences.user.name;
        };
      };
    };

    # Allows niri to inherit the full PATH set up by niri-session
    systemd.user.services.niri.enableDefaultPath = false;

    environment.systemPackages = [
      selfpkgs.terminal
      selfpkgs.noctalia-shell
      pkgs.xwayland-satellite
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.wl-clipboard
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    services.upower.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
