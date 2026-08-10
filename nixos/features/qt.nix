{
  flake.nixosModules.qt = {...}: {
    # Use Qt style set using the qt5ct and qt6ct applications,
    # which is where noctalia's qt template writes its colors.
    qt.enable = true;
    qt.platformTheme = "qt5ct";
  };
}
