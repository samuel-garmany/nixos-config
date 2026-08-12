{
  flake.nixosModules.nextcloud = {pkgs, ...}: let
    autostart = pkgs.makeDesktopItem {
      name = "Nextcloud";
      desktopName = "Nextcloud";
      genericName = "File Synchronizer";
      exec = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      icon = "Nextcloud";
      categories = ["Network"];
      terminal = false;
      startupNotify = false;
    };
  in {
    environment.systemPackages = [pkgs.nextcloud-client];

    environment.etc."xdg/autostart/Nextcloud.desktop".source = "${autostart}/share/applications/Nextcloud.desktop";
  };
}
