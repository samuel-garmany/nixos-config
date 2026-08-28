{
  flake.nixosModules.gnome = {pkgs, ...}: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages = with pkgs; [
      gnome-firmware
      pika-backup
    ];

    services.xserver.excludePackages = [pkgs.xterm];

    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      gnome-calculator
      gnome-calendar
      gnome-console
      gnome-contacts
      gnome-music
      gnome-software
      gnome-tour
      seahorse
      showtime
      simple-scan
      system-config-printer
      yelp
    ];
  };
}
