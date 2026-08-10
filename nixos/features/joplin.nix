{self, ...}: {
  flake.nixosModules.joplin = {pkgs, ...}: {
    imports = [
      self.nixosModules.firefox
    ];

    environment.systemPackages = with pkgs; [
      joplin-desktop
    ];

    programs.firefox.policies.ExtensionSettings = {
      # Allow and install specific extensions by their GUID
      "{8419486a-54e9-11e8-9401-ac9e17909436}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/joplin-web-clipper/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}
