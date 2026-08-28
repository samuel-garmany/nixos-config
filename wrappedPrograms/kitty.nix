{
  self,
  inputs,
  ...
}: {
  # Configuration of kitty.
  # See kitty.conf(5) or <https://sw.kovidgoyal.net/kitty/conf/>
  flake.wrappersModules.kitty = {
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
        shell = config.shell;
      }
      // {
        font_family = "Maple Mono NF";
        font_size = 12;

        # The enabled window layouts. A comma separated list of layout names.
        enabled_layouts = "splits,stack";

        window_padding_width = 6;
      };
  };

  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.terminal =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.kitty];
        shell = lib.getExe self'.packages.fish;
      }).wrapper;
  };
}
