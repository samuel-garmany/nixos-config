{
  flake.nixosModules.fonts = {
    pkgs,
    lib,
    ...
  }: {
    fonts.packages = with pkgs; [
      adwaita-fonts
      nerd-fonts.jetbrains-mono
    ];

    # plasma6 appends Noto and Hack to these lists, so ours go first.
    fonts.fontconfig.defaultFonts = {
      sansSerif = lib.mkBefore ["Adwaita Sans"];
      monospace = lib.mkBefore ["JetBrainsMono Nerd Font"];
    };
  };
}
