{inputs, ...}: {
  flake.nixosModules.nix = {pkgs, ...}: {
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

    # Allow insecure electron (still required by an installed package)
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    # Disable the NixOS manual
    documentation.nixos.enable = false;

    programs.direnv = {
      enable = true;
      silent = false;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      # Nix tooling
      nil
      nixd
      statix
      alejandra
      manix
      nix-inspect
    ];
  };
}
