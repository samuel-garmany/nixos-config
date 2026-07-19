{
  config.nixos.laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {

      networking.hostName = "laptop"; # Define your hostname.

      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
