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

  flake.nixosModules.hostDesktop = {...}: {
    imports = [
      self.nixosModules.shared

      self.nixosModules.gaming

      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
    ];

    networking.hostName = "desktop"; # Define your hostname.

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
