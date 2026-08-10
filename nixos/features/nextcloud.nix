{
  flake.nixosModules.nextcloud = {pkgs, ...}: {
    environment.systemPackages = [pkgs.nextcloud-client];

    systemd.user.services.nextcloud-client = {
      description = "Nextcloud Client";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        # Whether to start the Nextcloud client in the background.
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
        Restart = "on-abnormal";
      };
    };
  };
}
