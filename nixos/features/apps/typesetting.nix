{
  flake.nixosModules.typesetting = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      typst
      poppler-utils
    ];
  };
}
