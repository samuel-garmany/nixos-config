{
  flake.nixosModules.nautilus = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.nautilus
    ];

    # Trash, network shares and removable media for GTK file managers
    services.gvfs.enable = true;
  };
}
