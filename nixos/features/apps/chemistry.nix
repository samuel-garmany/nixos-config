{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.mnova = let
      pname = "mnova";
      version = "17.0.1-41952";

      src = pkgs.fetchurl {
        url = "https://mestrelab.com/downloads/mnova/linux/AppImage/MestReNova-${version}.AppImage";
        hash = "sha256-cFsnoDmz3jnI50gX5XWtvftZI5ln2xjInOo9skWRXWE=";
      };

      contents = pkgs.appimageTools.extract {inherit pname version src;};
    in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          install -m 444 -D ${contents}/MestReNova.desktop $out/share/applications/MestReNova.desktop
          install -m 444 -D ${contents}/usr/share/icons/hicolor/256x256/apps/MestReNova.png \
            $out/share/icons/hicolor/256x256/apps/MestReNova.png
          substituteInPlace $out/share/applications/MestReNova.desktop \
            --replace-fail 'Exec=MestReNova' 'Exec=mnova'
        '';
      };
  };

  flake.nixosModules.chemistry = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.mnova
    ];
  };
}
