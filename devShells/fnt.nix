{
  perSystem = {pkgs, ...}: let
    pythonEnv = pkgs.python312.withPackages (
      ps:
        with ps; [
          pip
          pyqt5
          setuptools
          wheel
        ]
    );

    # Libraries loaded at runtime by pip-installed manylinux wheels.
    runtimeLibs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glib
      libGL
      openssl
      libx11
      libxext
      libsm
      libice
    ];

    # Qt applications need this variable set to find the platform plugins.
    # https://nixos.org/manual/nixpkgs/stable/#sec-language-qt
    qtPlugins = with pkgs.qt5;
      pkgs.lib.concatStringsSep ":" (map (p: "${p}/${qtbase.qtPluginPrefix}") [
        qtbase.bin
        qtwayland.bin
        qtsvg.bin
      ]);
  in {
    devShells.fnt = pkgs.mkShell {
      packages =
        [pythonEnv]
        ++ (with pkgs; [
          # ffmpeg: Must be installed and added to your system PATH for video
          # processing features to work.
          ffmpeg
          git
          qt5.qtwayland
          uv
        ]);

      # Enable Wayland support for Qt applications.
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_PLUGIN_PATH = qtPlugins;

      shellHook = ''
        # Expose standard C libraries to pip-installed C-extensions.
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

        if [ -f pyproject.toml ]; then
          # Recreate the virtual environment when its interpreter is missing,
          # keeping site-packages. Leaves a dangling symlink in place otherwise.
          if [ ! -e .venv/bin/python ]; then
            rm -f .venv/bin/python .venv/bin/python3 .venv/bin/python3.*
            python -m venv .venv --system-site-packages
          fi

          source .venv/bin/activate
        fi
      '';
    };
  };
}
