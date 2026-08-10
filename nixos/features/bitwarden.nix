{self, ...}: {
  flake.nixosModules.bitwarden = {pkgs, ...}: {
    imports = [
      self.nixosModules.firefox
    ];

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];

    programs.firefox.policies.ExtensionSettings = {
      # Allow and install specific extensions by their GUID
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}
