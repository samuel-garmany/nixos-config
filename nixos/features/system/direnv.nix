{
  flake.nixosModules.direnv = {
    # direnv integration. Takes care of both installation and setting up the
    # sourcing of the shell. Additionally enables nix-direnv integration.
    programs.direnv.enable = true;
  };
}
