{
  perSystem = {pkgs, ...}: let
    python = pkgs.python312;
    pythonEnv = python.withPackages (ps:
      with ps; [
        pyqt5
        pip
        setuptools
        wheel
      ]);

    runtimeLibs = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib
      glib # libgthread, needed by cv2
      libGL
      openssl
      libx11
      libxext
      libsm
      libice
    ];

    qtPlugins = with pkgs.qt5;
      pkgs.lib.concatStringsSep ":" (map (p: "${p}/${qtbase.qtPluginPrefix}") [
        qtbase.bin
        qtwayland.bin
        qtsvg.bin
      ]);
  in {
    devShells.pyqt = pkgs.mkShell {
      packages =
        [pythonEnv]
        ++ (with pkgs; [
          uv
          # ffmpeg: Must be installed and added to your system PATH for video
          # processing features to work.
          ffmpeg
          git
          qt5.qtwayland
        ]);

      # Enable Wayland support for Qt applications.
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_PLUGIN_PATH = qtPlugins;

      shellHook = ''
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

        if [ ! -f pyproject.toml ]; then
          echo "pyqt shell ready (no pyproject.toml here, skipping venv setup)."
        else
          if [ ! -e .venv/bin/python ]; then
            if [ -d .venv ]; then
              echo "pyqt: .venv interpreter is missing or dangling, repairing in place"
              rm -f .venv/bin/python .venv/bin/python3 .venv/bin/python3.*
            fi
            python -m venv .venv --system-site-packages
          fi

          source .venv/bin/activate

          echo "pyqt shell ready."
          echo "  first run, or after pyproject.toml changes:  pip install -e ."
          echo "  launch the GUI:                              fnt"
        fi
      '';
    };
  };
}
