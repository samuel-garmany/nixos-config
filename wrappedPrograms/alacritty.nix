{
  self,
  inputs,
  ...
}: {
  # Configuration of alacritty.
  # See alacritty(5) or <https://alacritty.org/config-alacritty.html>
  flake.wrappersModules.alacritty = {
    config,
    lib,
    ...
  }: {
    options.shell = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    config.settings =
      lib.optionalAttrs (config.shell != "") {
        terminal.shell.program = config.shell;
      }
      // {
        general.import = ["~/.config/alacritty/themes/noctalia.toml"];

        window = {
          padding = {
            x = 6;
            y = 6;
          };
          dynamic_padding = true;
        };
      };
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.terminal =
      (inputs.wrappers.wrapperModules.alacritty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.alacritty];
        shell = lib.getExe pkgs.fish;
      }).wrapper;
  };
}
