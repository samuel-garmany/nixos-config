{
  perSystem = {pkgs, ...}: {
    devShells.r = pkgs.mkShell {
      packages = with pkgs; [
        R
        rPackages.styler
        rPackages.rmarkdown
        rPackages.knitr
        rPackages.tidyverse
        rPackages.lubridate

        pandoc
      ];

      shellHook = ''
        mkdir -p .Rlibs
        export R_LIBS_USER="$(pwd)/.Rlibs"
      '';
    };
  };
}
