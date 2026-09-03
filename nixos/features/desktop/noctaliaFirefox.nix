{self, ...}: {
  flake.nixosModules.noctaliaFirefox = {
    lib,
    pkgs,
    ...
  }: let
    pywalfox = lib.getExe pkgs.pywalfox-native;

    nativeMessagingHost = pkgs.runCommand "pywalfox-native-messaging-host" {} ''
      ${pywalfox} install \
        --executable ${pywalfox} \
        --manifest-path $out/lib/mozilla/native-messaging-hosts
    '';
  in {
    imports = [
      self.nixosModules.firefox
    ];

    # noctalia's pywalfox template runs `pywalfox <mode>` and `pywalfox update`
    environment.systemPackages = [
      pkgs.pywalfox-native
    ];

    programs.firefox.nativeMessagingHosts.packages = [
      nativeMessagingHost
    ];

    programs.firefox.policies.ExtensionSettings = {
      # Allow and install specific extensions by their GUID
      "pywalfox@frewacom.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
}
