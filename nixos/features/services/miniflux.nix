{self, ...}: {
  flake.nixosModules.miniflux = {config, ...}: let
    # tailscale serve proxies / to this port.
    port = 8082;

    hostName = "${config.networking.hostName}.${self.tailnet}";
  in {
    sops.secrets.miniflux-admin-credentials = {};

    services.miniflux = {
      enable = true;

      adminCredentialsFile = config.sops.secrets.miniflux-admin-credentials.path;

      config = {
        LISTEN_ADDR = "127.0.0.1:${toString port}";
        BASE_URL = "https://${hostName}:8446/";

        # Supported values are round_robin and entry_frequency.
        POLLING_SCHEDULER = "entry_frequency";

        # Number of days after marking read entries as removed. Set to -1 to
        # keep all read entries.
        CLEANUP_ARCHIVE_READ_DAYS = -1;

        # Set the value to 1 to scrape video duration from YouTube website and
        # use it as a reading time.
        FETCH_YOUTUBE_WATCH_TIME = 1;
      };
    };
  };
}
