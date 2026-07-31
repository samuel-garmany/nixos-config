{
  config.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;

    services.displayManager.autoLogin = {
      enable = true;
      # Replace `yourUserName` with the actual username of user who should be automatically logged in
      user = "user";
    };

    services.system76-scheduler.enable = true;

    programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };

    environment.systemPackages = with pkgs; [
      baobab
      cosmic-ext-calculator
      gnome-characters
      gnome-disk-utility
      gnome-maps
      gocryptfs
      snapshot
    ];

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-store
    ];
  };
}
