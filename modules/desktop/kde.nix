{
  config.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # Enable Plasma and login manager
    services = {
      desktopManager.plasma6.enable = true;

      # Default display manager for Plasma with auto-login for default user
      displayManager.plasma-login-manager.enable = true;
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "user";

      # Optionally enable xserver
      # xserver.enable = true;
    };

    # Disable getty/autovt on tty1 when auto-login is enabled to prevent a race condition
    systemd.services."getty@tty1".enable = lib.mkForce false;
    systemd.services."autovt@tty1".enable = lib.mkForce false;

    # Exclude default Plasma applications that are replaced by preferred alternatives (e.g., Konsole -> Kitty)
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      konsole
      elisa
    ];

    # Explicitly install desired KDE Plasma ecosystem applications and utilities
    environment.systemPackages = with pkgs.kdePackages; [
      filelight
      gwenview
      kamoso
      kate
      kcalc
      kcharselect
      krdc
      marble
      okular
      plasma-browser-integration
      plasma-vault
    ];

    programs.firefox.policies.ExtensionSettings = {
      # Allow and install specific extensions by their GUID
      "plasma-browser-integration@kde.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    # Allow KDE Plasma location services in Geoclue
    services.geoclue2.appConfig = {
      "org.kde.kwin_wayland" = {
        isAllowed = true;
        isSystem = true;
      };
      "org.kde.kwin_x11" = {
        isAllowed = true;
        isSystem = true;
      };
      "org.kde.kded6" = {
        isAllowed = true;
        isSystem = true;
      };
      "org.kde.plasma.workspace" = {
        isAllowed = true;
        isSystem = true;
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
