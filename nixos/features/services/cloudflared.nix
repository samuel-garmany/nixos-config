{
  flake.nixosModules.cloudflared = {
    config,
    lib,
    pkgs,
    ...
  }: {
    sops.secrets.cloudflared-token = {};

    # services.cloudflared only covers locally-managed tunnels. This one is run
    # from a token, so the unit is the one `cloudflared service install` writes:
    # cloudflared/cmd/cloudflared/linux_service.go
    systemd.services.cloudflared = {
      description = "Cloudflare Tunnel client";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        TimeoutStartSec = 15;
        Type = "notify";
        ExecStart = "${lib.getExe pkgs.cloudflared} --no-autoupdate tunnel run --token-file ${config.sops.secrets.cloudflared-token.path}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
