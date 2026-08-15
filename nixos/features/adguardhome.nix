{
  flake.nixosModules.adguardhome = {...}: {
    services.adguardhome.enable = true;

    # Merged over the file on every start, so these outlive the web interface.
    services.adguardhome.settings = {
      dns = {
        # The default is Quad9 unsecured, which Quad9 suggests is not used for
        # more than testing purposes as there are no protections provided.
        upstream_dns = ["https://dns.quad9.net/dns-query"];
        bootstrap_dns = ["9.9.9.9" "149.112.112.112" "2620:fe::fe"];

        enable_dnssec = true;
        edns_client_subnet.enabled = false;
      };

      # Every device on the tailnet resolves through here. The default is 90d.
      querylog.interval = "24h";
    };

    # openFirewall does not open the port needed to access the DNS resolver.
    networking.firewall.allowedTCPPorts = [53];
    networking.firewall.allowedUDPPorts = [53];
  };
}
