{
  config.nixos.base =
    { ... }:
    {
      security.apparmor.enable = true;
    };
}
