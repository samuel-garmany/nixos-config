{self, ...}: {
  flake.nixosModules.general = {pkgs, ...}: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.environment
      self.nixosModules.git
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${self.username} = {
      isNormalUser = true;
      description = self.fullName;
      extraGroups = [
        "dialout"
        "networkmanager"
        "wheel"
      ];
    };

    # Also wanted outside the login shell: by root, by scripts and by GUI apps
    environment.systemPackages = [
      pkgs.unzip
    ];
  };
}
