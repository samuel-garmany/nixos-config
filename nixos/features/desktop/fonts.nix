{
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      adwaita-fonts
      maple-mono.NF
    ];

    fonts.fontconfig.defaultFonts = {
      sansSerif = ["Adwaita Sans"];
      monospace = ["Maple Mono NF"];
    };

    programs.dconf.profiles.user.databases = [
      {
        lockAll = false;
        settings."org/gnome/desktop/interface".monospace-font-name = "Maple Mono NF 12";
      }
    ];
  };
}
