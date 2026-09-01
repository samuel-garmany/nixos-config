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
  };
}
