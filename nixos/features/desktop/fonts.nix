{
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      adwaita-fonts
      caladea
      carlito
      nerd-fonts.symbols-only
    ];

    fonts.fontconfig.defaultFonts = {
      sansSerif = ["Adwaita Sans"];
      monospace = ["Adwaita Mono" "Symbols Nerd Font Mono"];
    };
  };
}
