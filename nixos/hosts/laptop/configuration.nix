{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLaptop
    ];
  };

  flake.nixosModules.hostLaptop = {
    imports = [
      self.nixosModules.workstation

      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    networking.hostName = "laptop"; # Define your hostname.

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
