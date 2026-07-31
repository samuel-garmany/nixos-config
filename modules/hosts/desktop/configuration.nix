{
  config.nixos.desktop = {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.hostName = "desktop"; # Define your hostname.

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
