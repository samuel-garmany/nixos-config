{self, ...}: {
  flake.nixosModules.calibreWeb = {
    config,
    pkgs,
    ...
  }: let
    # cloudflared proxies / to this port.
    port = 8083;
  in {
    services.calibre-web = {
      enable = true;

      package = pkgs.calibre-web.overridePythonAttrs (prev: {
        dependencies = prev.dependencies ++ prev.optional-dependencies.kobo;
      });

      listen = {
        # IP address that Calibre-Web should listen on.
        ip = "127.0.0.1";

        # Listen port for Calibre-Web.
        port = 8084;
      };

      options = {
        calibreLibrary = "/mnt/data/calibre-web";
        enableBookUploading = true;
        enableKepubify = true;
      };
    };

    # https://github.com/janeczku/calibre-web/wiki/Setup-Reverse-Proxy
    services.nginx.virtualHosts.${self.calibreDomain} = {
      listen = [
        {
          addr = "127.0.0.1";
          inherit port;
        }
      ];

      extraConfig = ''
        client_max_body_size 20M;
      '';

      locations."/" = {
        proxyPass = "http://${config.services.calibre-web.listen.ip}:${toString config.services.calibre-web.listen.port}";
        extraConfig = ''
          proxy_bind              $server_addr;
          proxy_set_header        Host            $host;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Scheme        $http_x_forwarded_proto;
          proxy_set_header        X-Forwarded-Host $host;
        '';
      };
    };
  };
}
