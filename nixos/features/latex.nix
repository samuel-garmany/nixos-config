{
  flake.nixosModules.latex = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      texliveFull
      typst
      ltex-ls
      poppler-utils
    ];
  };
}
