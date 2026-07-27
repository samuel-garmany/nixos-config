{config, ...} @ topArgs: {
  config.nixos.base = {
    pkgs,
    lib,
    ...
  } @ nixosArgs: {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."user" = {
      isNormalUser = true;
      description = "Samuel Garmany";
      extraGroups = [
        "dialout"
        "networkmanager"
        "wheel"
      ];
      # Set fish as the default shell for a specific user
      # Note: Using Fish as your login shell can occasionally cause issues because Fish is not POSIX-compliant.
      shell = pkgs.fish;
      packages = with pkgs; [
        #  thunderbird
      ];
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
  };

  config.nixos.desktop = {...}: {
    home-manager.users."user" = topArgs.config.hm.desktop;
  };

  config.nixos.laptop = {...}: {
    home-manager.users."user" = topArgs.config.hm.laptop;
  };

  config.hm.base = {...}: {
    home.stateVersion = "26.05";
  };
}
