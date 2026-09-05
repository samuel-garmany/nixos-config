{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Recursively import Nix modules from a directory, with a simple,
    # extensible API. By default, paths having `/_` are ignored.
    # https://github.com/denful/import-tree
    import-tree.url = "github:denful/import-tree";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Package wrappers: configuration baked into the package instead of into $HOME
    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Lanzaboote handles Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Atomic secret provisioning for NixOS based on sops
    # https://github.com/Mic92/sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Open-source modding framework for creating and managing Steam Client
    # themes and plugins.
    # https://github.com/SteamClientHomebrew/Millennium
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree [
      ./parts.nix
      ./devShells
      ./nixos
      ./wrappedPrograms
    ]);
}
