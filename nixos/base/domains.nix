{lib, ...}: {
  options.flake = {
    # Tailscale assigns your tailnet a unique DNS name, such as tail0250.ts.net.
    # https://tailscale.com/kb/1217/tailnet-name
    tailnet = lib.mkOption {
      type = lib.types.str;
    };

    vaultDomain = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.flake = {
    tailnet = "tail5c3838.ts.net";
    vaultDomain = "vault.garmany.me";
  };
}
