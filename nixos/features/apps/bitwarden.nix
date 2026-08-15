{self, ...}: {
  flake.nixosModules.bitwarden = {pkgs, ...}: let
    autostart = pkgs.makeDesktopItem {
      name = "bitwarden";
      desktopName = "Bitwarden";
      comment = "Bitwarden startup script";
      exec = "${pkgs.bitwarden-desktop}/bin/bitwarden --autostart";
      terminal = false;
      startupNotify = false;
    };
  in {
    imports = [
      self.nixosModules.firefox
    ];

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];

    environment.etc."xdg/autostart/bitwarden.desktop".source = "${autostart}/share/applications/bitwarden.desktop";

    programs.firefox.policies.ExtensionSettings = {
      # Allow and install specific extensions by their GUID
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    # Most installations will only require the base URL, however some unique
    # setups may require you to enter URLs for each service independently.
    # https://bitwarden.com/help/browserext-deploy/
    programs.firefox.policies."3rdparty".Extensions = {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}".environment.base = "https://${self.vaultDomain}";
    };
  };
}
