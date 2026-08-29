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
              kscreenlockerrc
              ksmserverrc
              plasmarc
              breezerc
              dolphinrc
              konsolerc
            "

            # Paths under $HOME are per-machine, wallpapers especially. Dropping
            # the line leaves the key at its default rather than pointing at a
            # file that may not exist.
            strip_home() {
              sed -i "\|$HOME|d" "$1"
            }

            for f in $files; do
              if [ -f "$HOME/.config/$f" ]; then
                install -m 0644 "$HOME/.config/$f" "$dest/$f"
                strip_home "$dest/$f"
                echo "dumped $f"
              fi
            done

            # Konsole keeps profiles and colour schemes under the data
            # directory rather than the config one.
            for f in "$HOME"/.local/share/konsole/*.profile                      "$HOME"/.local/share/konsole/*.colorscheme; do
              if [ -f "$f" ]; then
                install -D -m 0644 "$f" "$dest/konsole/$(basename "$f")"
                strip_home "$dest/konsole/$(basename "$f")"
                echo "dumped konsole/$(basename "$f")"
              fi
            done
          '';
        });
    };
  };
}
