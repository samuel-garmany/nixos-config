{
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      maple-mono.NF
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = ["Maple Mono NF"];
    };
  };
}
