{
  flake.nixosModules.printing = {pkgs, ...}: {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    environment.extraSetup = ''
      rm -f $out/share/applications/cups.desktop
    '';
  };
}
