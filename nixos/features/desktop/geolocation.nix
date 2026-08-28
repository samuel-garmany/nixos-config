{
  flake.nixosModules.geolocation = {lib, ...}: {
    # Enable automatic timezone and location services for weather and Night Light (Wi-Fi & IP fallback)
    services.automatic-timezoned.enable = true;
    services.geoclue2 = {
      enable = true;
      enableDemoAgent = lib.mkForce true;
      enableWifi = true;
      appConfig = {
        "org.kde.kwin_wayland" = {
          isAllowed = true;
          isSystem = true;
        };
        "org.kde.kded6" = {
          isAllowed = true;
          isSystem = true;
        };
        "org.kde.plasma.workspace" = {
          isAllowed = true;
          isSystem = true;
        };
        "thunderbird" = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };
  };
}
