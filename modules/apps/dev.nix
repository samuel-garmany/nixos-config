{
  config.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        arduino-ide
      ];
    };
}
