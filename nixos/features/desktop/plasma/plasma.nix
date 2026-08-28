{
  flake.nixosModules.plasma = {
    pkgs,
    lib,
    ...
  }: {
    services.desktopManager.plasma6.enable = true;

    # plasma6 configures sddm (breeze theme, kwin as the wayland compositor)
    # but does not enable it.
    services.displayManager.sddm.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages = with pkgs.kdePackages; [
      filelight
      gwenview
      kate
      okular
    ];

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];

    # KConfig reads $XDG_CONFIG_DIRS after $XDG_CONFIG_HOME, so every file
    # dumped into ./config becomes a default that System Settings overrides.
    environment.etc =
      lib.mapAttrs'
      (name: _: lib.nameValuePair "xdg/${name}" {source = ./config + "/${name}";})
      (lib.filterAttrs
        (name: type: type == "regular" && !lib.hasPrefix "." name)
        (builtins.readDir ./config));

    environment.extraSetup = ''
      rm -f $out/share/applications/btop.desktop
      rm -f $out/share/applications/cups.desktop
      rm -f $out/share/applications/nixos-manual.desktop
      rm -f $out/share/applications/nvim.desktop
      rm -f $out/share/applications/yazi.desktop
    '';
  };
}
