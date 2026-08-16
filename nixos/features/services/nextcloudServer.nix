{self, ...}: {
  flake.nixosModules.nextcloudServer = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # tailscale serve proxies / to this port.
    port = 8080;

    hostName = "${config.networking.hostName}.${self.tailnet}";
  in {
    sops.secrets.nextcloud-adminpass = {};
    sops.secrets.nextcloud-secrets = {};

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud34;

      inherit hostName;
      datadir = "/mnt/data/nextcloud";
      https = true;

      configureRedis = true;
      database.createLocally = true;

      config = {
        dbtype = "pgsql";
        adminpassFile = config.sops.secrets.nextcloud-adminpass.path;
      };

      # secret and passwordsalt, carried over from the previous instance.
      secretFile = config.sops.secrets.nextcloud-secrets.path;

      settings = {
        overwriteprotocol = "https";
        "overwrite.cli.url" = "https://${hostName}/";
        trusted_proxies = ["127.0.0.1" "::1"];

        # UTC Hour for maintenance windows
        maintenance_window_start = 8;

        # The preview providers that should be explicitly enabled.
        # The module default, plus HEIC for iPhone stills.
        enabledPreviewProviders = [
          "OC\\Preview\\PNG"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\GIF"
          "OC\\Preview\\BMP"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\Krita"
          "OC\\Preview\\WebP"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\TXT"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\HEIC"
        ];
      };

      extraApps = {
        inherit (pkgs.nextcloud34Packages.apps) calendar contacts tasks deck;
      };

      notify_push.enable = true;
    };

    # The default follows system.stateVersion and lands on 17; the database was
    # dumped from 18.
    services.postgresql.package = pkgs.postgresql_18;

    services.postgresqlBackup = {
      enable = true;
      # Path of directory where the PostgreSQL database dumps will be placed.
      location = "/mnt/data/backups/postgresql";
    };

    # Cache and lock store only. An empty list writes save "", disabling
    # snapshots.
    services.redis.servers.nextcloud.save = [];

    services.nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
      {
        addr = "127.0.0.1";
        inherit port;
      }
    ];

    # tailscale serve replaces x-forwarded-for, so notify_push cannot prove it
    # is a trusted proxy over the public hostname. notify_push:setup keeps that
    # hostname, since it is what clients connect to.
    systemd.services.nextcloud-notify_push.environment.NEXTCLOUD_URL =
      lib.mkForce "http://127.0.0.1:${toString port}";
  };
}
