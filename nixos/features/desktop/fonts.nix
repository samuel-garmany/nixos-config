{
  flake.nixosModules.fonts = {
    pkgs,
    lib,
    ...
  }: {
    fonts.packages = with pkgs; [
      adwaita-fonts
      maple-mono.NF
    ];

    # plasma6 appends Noto and Hack to these lists, so ours go first.
    fonts.fontconfig.defaultFonts = {
      sansSerif = lib.mkBefore ["Adwaita Sans"];
      monospace = lib.mkBefore ["Maple Mono NF"];
    };
  };
}
