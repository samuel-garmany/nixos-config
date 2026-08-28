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
        # The first listed layout will be used as the startup layout.
        enabled_layouts = "splits,stack";

        # The edge to show the tab bar on, top, bottom, left or right.
        tab_bar_edge = "top";

        # Number of lines of history to keep in memory for scrolling back.
        scrollback_lines = 10000;

        # Show a desktop notification when a long-running command finishes
        # (needs shell_integration).
        notify_on_cmd_finish = "unfocused";

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
