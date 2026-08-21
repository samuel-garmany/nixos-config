{
  perSystem = {pkgs, ...}: {
    devShells.latex = pkgs.mkShell {
      packages = with pkgs; [
        texliveFull
      ];
    };
  };
}
