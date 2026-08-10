{
  flake.nixosModules.printing = {...}: {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    environment.extraSetup = ''
      rm -f $out/share/applications/cups.desktop
    '';
  };
}
