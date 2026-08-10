{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.nix
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      description = "Samuel Garmany";
      extraGroups = [
        "dialout"
        "networkmanager"
        "wheel"
      ];
      # Set fish as the default shell for a specific user
      # Note: Using Fish as your login shell can occasionally cause issues because Fish is not POSIX-compliant.
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
    };

    # Enable fish system-wide
    # It is recommended to enable fish system-wide,
    # to ensure that vendor completions provided by packages in the system profile are available.
    programs.fish.enable = true;
    environment.shells = [self.packages.${pkgs.stdenv.hostPlatform.system}.environment];

    # Also wanted outside the login shell: by root, by scripts and by GUI apps
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
      pkgs.unzip
    ];
  };
}
