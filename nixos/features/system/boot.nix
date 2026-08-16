{inputs, ...}: {
  flake.nixosModules.boot = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    # Bootloader.
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      loader.efi.canTouchEfiVariables = true;

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      # Required for plymouth to draw the LUKS passphrase prompt
      initrd.systemd.enable = true;

      plymouth.enable = true;

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];

      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      loader.timeout = 0;
    };

    environment.systemPackages = [pkgs.sbctl];
  };
}
