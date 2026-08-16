{
  flake.nixosModules.geolocation = {lib, ...}: {
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
  };
}
