{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostDesktop
    ];
  };

  flake.nixosModules.hostDesktop = {
    imports = [
      self.nixosModules.workstation

      self.nixosModules.gaming
      self.nixosModules.noctaliaSteam

      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
    ];

    networking.hostName = "desktop"; # Define your hostname.

    # Devices which should not be displayed in the user interface.
    # lib/udev/rules.d/80-udisks2.rules
    #
    # The other two devices of the root pool. They report the filesystem UUID
    # rather than one of their own, so they are matched by mapper name.
    services.udev.extraRules = ''
      ENV{DM_NAME}=="luks-d57a23be-cf31-405e-ac09-9cb06e6331c1", ENV{UDISKS_IGNORE}="1"
      ENV{DM_NAME}=="luks-5a37508d-66a3-40ba-a228-cdeb5606e521", ENV{UDISKS_IGNORE}="1"
    '';

    # List of systems to emulate using qemu-user.
    # Warning: the emulation slows down the compilation.
    # Builds the aarch64 closure for the server.
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
