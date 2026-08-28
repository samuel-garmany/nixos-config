{
  perSystem = {pkgs, ...}: {
    apps.dumpPlasma = {
      type = "app";
      program =
        pkgs.lib.getExe
        (pkgs.writeShellApplication {
          name = "dump-plasma";
          runtimeInputs = [pkgs.coreutils];
          text = ''
            dest="''${1:-nixos/features/desktop/plasma/config}"
            [ -d "$dest" ] || { echo "no $dest -- run from the flake root"; exit 1; }

            files="
              kdeglobals
              kwinrc
              kcminputrc
              kglobalshortcutsrc
              kscreenlockerrc
              ksmserverrc
              plasmarc
              plasma-org.kde.plasma.desktop-appletsrc
              powermanagementprofilesrc
              breezerc
              dolphinrc
              konsolerc
            "

            for f in $files; do
              if [ -f "$HOME/.config/$f" ]; then
                install -m 0644 "$HOME/.config/$f" "$dest/$f"
                echo "dumped $f"
              fi
            done
          '';
        });
    };
  };
}
