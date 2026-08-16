{inputs, ...}: {
  flake.nixosModules.sober = {
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];

    # Configure nix-flatpak
    services.flatpak = {
      enable = true;
      packages = [
        "org.vinegarhq.Sober"
      ];
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
