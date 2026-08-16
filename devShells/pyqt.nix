{
  perSystem = {pkgs, ...}: {
    devShells.pyqt = pkgs.mkShell {
      packages = with pkgs; [
        uv
        # ffmpeg: Must be installed and added to your system PATH for video
        # processing features to work.
        ffmpeg
        git
      ];

      # Enable Wayland support for Qt applications.
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
