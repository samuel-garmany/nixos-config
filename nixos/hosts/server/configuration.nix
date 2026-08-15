{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostServer
    ];
  };

  flake.nixosModules.hostServer = {pkgs, ...}: {
    imports = [
      self.nixosModules.general

      # system
      self.nixosModules.security
      self.nixosModules.sops
      self.nixosModules.tailscale

      # services
      self.nixosModules.adguardhome
      self.nixosModules.calibre-web
      self.nixosModules.cloudflared
      self.nixosModules.nextcloudServer
      self.nixosModules.vaultwarden
    ];

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    # The serial ports listed here are:
    # - ttyS0: for Tegra (Jetson TX1)
    # - ttyAMA0: for QEMU's -machine virt
    boot.kernelParams = [
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
    ];

    networking.hostName = "server"; # Define your hostname.

    time.timeZone = "America/Denver";
    i18n.defaultLocale = "en_US.UTF-8";

    # journald cannot move to the SSD, which is unlocked long after it starts.
    services.journald.extraConfig = "SystemMaxUse=200M";

    zramSwap.enable = true;

    swapDevices = [
      {
        device = "/mnt/data/swapfile";
        size = 4 * 1024;
      }
    ];

    services.openssh = {
      enable = true;
      settings = {
        # Specifies whether password authentication is allowed.
        PasswordAuthentication = false;
        # Specifies whether keyboard-interactive authentication is allowed.
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.root.openssh.authorizedKeys.keys = self.authorizedKeys;
    users.users.${self.username}.openssh.authorizedKeys.keys = self.authorizedKeys;

    system.autoUpgrade = {
      enable = true;
      flake = "github:samuel-garmany/nixos-config#server";
      dates = "weekly";
    };

    environment.systemPackages = [pkgs.cryptsetup];

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
