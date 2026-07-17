{
  config.nixos.base =
    { ... }:
    {
      services.tailscale.enable = true;
    };
}
