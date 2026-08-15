{
  flake.nixosModules.adguardhome = {...}: {
    services.adguardhome = {
      enable = true;

      # Host address to bind HTTP server to.
      host = "127.0.0.1";

      settings = {
        dns = {
          # Quad9 suggests the unsecured service, which is the AdGuard Home
          # default, is not used for more than testing purposes as there are no
          # protections provided.
          upstream_dns = ["https://dns.quad9.net/dns-query"];
          bootstrap_dns = ["9.9.9.9" "149.112.112.112" "2620:fe::fe"];

          enable_dnssec = true;
          edns_client_subnet.enabled = false;
        };

        querylog.interval = "24h";
      };
    };

    # openFirewall does not open the port needed to access the DNS resolver.
    networking.firewall.allowedTCPPorts = [53];
    networking.firewall.allowedUDPPorts = [53];
  };
}
