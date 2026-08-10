{self, ...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    imports = [
      self.nixosModules.sober
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    environment.systemPackages = with pkgs; [
      discord
      faugus-launcher
      prismlauncher
    ];
  };
}
