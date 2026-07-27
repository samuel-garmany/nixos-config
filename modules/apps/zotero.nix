{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zotero
      ];

      programs.firefox.policies.ExtensionSettings = {
        # Allow and install specific extensions by their GUID
        "zotero@chnm.gmu.edu" = {
          install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
          installation_mode = "force_installed";
        };
      };
    };
}
