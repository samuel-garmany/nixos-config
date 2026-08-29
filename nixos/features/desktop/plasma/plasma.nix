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

    # plasma6 turns this on by default; it installs akonadi, and kmail and
    # merkuro are separate options that stay off.
    programs.kde-pim.enable = false;

    programs.firefox.policies.ExtensionSettings = {
      "plasma-browser-integration@kde.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages =
      (with pkgs.kdePackages; [
        filelight
        plasma-vault
      ])
      # Konsole reads profiles from the konsole subdirectory of each
      # $XDG_DATA_DIRS entry, not from the config directory.
      ++ lib.optional (builtins.pathExists ./config/konsole) (
        pkgs.runCommandLocal "konsole-profiles" {} ''
          mkdir -p $out/share/konsole
          cp ${./config/konsole}/* $out/share/konsole/
        ''
      );

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
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
  };
}
