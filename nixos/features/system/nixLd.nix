{
  flake.nixosModules.nixLd = {pkgs, ...}: {
    # nix-ld, Documentation: <https://github.com/nix-community/nix-ld>
    programs.nix-ld.enable = true;

    # Libraries that automatically become available to all programs.
    # The default set includes common libraries.
    programs.nix-ld.libraries = with pkgs; [
      dbus
      fontconfig
      freetype
      glib
      libGL
      libICE
      libSM
      libX11
      libXext
      libxcb
      libxkbcommon
      wayland
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ];
  };
}
