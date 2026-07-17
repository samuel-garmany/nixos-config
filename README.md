# NixOS Configuration

A modular and declarative NixOS setup managed via Flakes. It heavily utilizes `flake-parts` to organize system configurations and reusable modules across different hosts.

## Architecture Map

The mindmap below visualizes the entire flake architecture. It is **auto-generated** on push by a GitHub Action that parses the Nix schema (`nix flake show` & `metadata`) and scans the local repository structure to map inputs, local modules, and final outputs.

## Flake Map

<!-- FLAKE_MAP_START -->
```mermaid
mindmap
  root((flake.nix))
    Inputs
      flake-parts
      home-manager
      lanzaboote
      nixos-hardware
      nixpkgs
      nvf
    Local Repository
      Hosts
        desktop
        laptop
      Modules
        Apps
          communication
          dev
          firefox
          gaming
          git
          joplin
          media
          neovim
          nextcloud
          office
          thunderbird
          writing
          zotero
        Cli
          bat
          eza
          fzf
          utils
          zoxide
        Core
          boot
          hardware
          locale
          networking
          nix
          options
          packages
          security
          tailscale
        Desktop
          audio
          fonts
          gnome
          printing
        Shells
          direnv
          fish
          pyqt
          r
          starship
        Users
          user
    Outputs
      devShells
        x86_64-linux
          pyqt
          r
      nixosConfigurations
        desktop
        laptop
```
<!-- FLAKE_MAP_END -->
