{
  perSystem = {pkgs, ...}: {
    devShells.arduino = pkgs.mkShell {
      packages = with pkgs; [
        # Arduino CLI is an all-in-one solution that provides Boards/Library
        # Managers and sketch builder.
        # https://github.com/arduino/arduino-cli
        arduino-cli

        git
      ];
    };
  };
}
