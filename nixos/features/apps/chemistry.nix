{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.mnova = pkgs.appimageTools.wrapType2 (finalAttrs: {
      pname = "mnova";
      version = "17.0.1-41952";

      src = pkgs.fetchurl {
        url = "https://mestrelab.com/downloads/mnova/linux/AppImage/MestReNova-${finalAttrs.version}.AppImage";
        hash = "sha256-cFsnoDmz3jnI50gX5XWtvftZI5ln2xjInOo9skWRXWE=";
      };

      extraInstallCommands = ''
        install -m 444 -D ${finalAttrs.contents}/MestReNova.desktop $out/share/applications/MestReNova.desktop
        install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/256x256/apps/MestReNova.png \
          $out/share/icons/hicolor/256x256/apps/MestReNova.png
        substituteInPlace $out/share/applications/MestReNova.desktop \
          --replace-fail 'Exec=MestReNova' 'Exec=mnova'
      '';
    });
  };

  flake.nixosModules.chemistry = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.jchempaint
      self.packages.${pkgs.stdenv.hostPlatform.system}.mnova
    ];
  };
}
