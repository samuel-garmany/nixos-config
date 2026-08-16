{inputs, ...}: {
  flake.nixosModules.nix = {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];
    programs.nix-index-database.comma.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable flakes, nix command, and optimize storage
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    # Weekly garbage collect
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
