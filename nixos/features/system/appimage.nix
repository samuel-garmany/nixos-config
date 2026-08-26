{
  flake.nixosModules.appimage = {
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
  };
}
