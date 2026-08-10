{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # The framework I use to structure the flake, module imports are automatic via custom function below
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Package wrappers: configuration baked into the package instead of into $HOME
    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Declarative dotfiles for the few things a wrapper cannot cover
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote handles Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    # Not in nixpkgs; `nix flake update r-nvim` bumps it, the lock records the rev
    r-nvim = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
  };

  # Import all .nix files from current directory except flake.nix recursively
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNixModule = file:
      file.hasExt "nix"
      && file.name != "flake.nix"
      && !lib.hasPrefix "_" file.name;

    importTree = path:
      toList (fileFilter isNixModule path);

    mkFlake = inputs.flake-parts.lib.mkFlake {inherit inputs;};
  in
    mkFlake {imports = importTree ./.;};
}
