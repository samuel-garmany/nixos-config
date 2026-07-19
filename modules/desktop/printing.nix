{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Enable CUPS to print documents.
      services.printing.enable = true;

      environment.extraSetup = ''
        rm -f $out/share/applications/cups.desktop
      '';
    };
}
