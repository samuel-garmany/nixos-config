{
  flake.nixosModules.networking = {
    # Enable networking
    networking.networkmanager.enable = true;
    # Specify the Wi-Fi backend used for the device.
    # Currently supported are wpa_supplicant or iwd (experimental).
    # networking.networkmanager.wifi.backend = "iwd";
  };
}
