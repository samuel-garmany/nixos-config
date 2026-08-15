{
  flake.nixosModules.locale = {lib, ...}: {
    # Enable automatic timezone and location services for weather and Night Color (Wi-Fi & IP fallback)
    services.automatic-timezoned.enable = true;
    services.geoclue2 = {
      enable = true;
      enableDemoAgent = lib.mkForce true;
      enableWifi = true;
      appConfig = {
        "gammastep" = {
          isAllowed = true;
          isSystem = false;
        };
        "redshift" = {
          isAllowed = true;
          isSystem = false;
        };
        "thunderbird" = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
