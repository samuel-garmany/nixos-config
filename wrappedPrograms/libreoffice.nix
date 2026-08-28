{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.libreoffice = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.libreoffice;

      # Specifies which style of the symbols is used for the toolbars, menus,
      # etc.: auto means chosen according to the desktop.
      # officecfg/registry/schema/org/openoffice/Office/Common.xcs
      #
      # none pairs colibre with colibre_dark; gnome pairs elementary with
      # sifr_dark.
      # vcl/source/app/IconThemeSelector.cxx
      # env.OOO_FORCE_DESKTOP = "none";
    };
  };

  flake.nixosModules.libreoffice = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.libreoffice
      pkgs.jre8
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
      pkgs.hyphenDicts.en_US
    ];
  };
}
