{
  config.hm.base = { ... }: {
    programs.kitty = {
      enable = true;

      # The font to use.
      font = {
        name = "Maple Mono NF";
      };

      # Apply a Kitty color theme. This option takes the file name of a theme
      # in `kitty-themes`, without the `.conf` suffix. See
      # <https://github.com/kovidgoyal/kitty-themes/tree/master/themes> for a
      # list of themes.
      # 
      # Note that if any automatic themes are configured via
      # `programs.kitty.autoThemeFiles`, Kitty will prefer them based on the
      # OS color scheme and they will override other color and background image
      # settings.
      themeFile = "gruvbox-dark";

      # Configure Kitty automatic color themes. This creates
      # {file}`$XDG_CONFIG_HOME/kitty/light-theme.auto.conf`,
      # {file}`$XDG_CONFIG_HOME/kitty/dark-theme.auto.conf`, and
      # {file}`$XDG_CONFIG_HOME/kitty/no-preference-theme.auto.conf`.
      # Kitty applies these based on the OS color scheme, and they override
      # other color and background image settings.
      autoThemeFiles = {
        # Theme name for light color scheme.
        light = "gruvbox-light-hard";
        # Theme name for dark color scheme.
        dark = "gruvbox-dark";
        # Theme name for no-preference color scheme.
        noPreference = "gruvbox-dark";
      };

      settings = {
        # Choose between Wayland and X11 backends. By default, an appropriate
        # backend based on the system state is chosen automatically. Set it
        # to x11 or wayland to force the choice. Changing this option by
        # reloading the config is not supported.
        linux_display_server = "auto";

        # The color of the kitty window's titlebar on Wayland systems with
        # client side window decorations such as GNOME. A value of system
        # means to use the default system colors, a value of background means
        # to use the background color of the currently active kitty window
        # and finally you can use an arbitrary color, such as #12af59 or red.
        wayland_titlebar_color = "system";

        # The audio bell. Useful to disable it in environments that require
        # silence.
        enable_audio_bell = false;

        # Ask for confirmation when closing an OS window or a tab with at
        # least this number of kitty windows in it by window manager (e.g.
        # clicking the window close button or pressing the operating system
        # shortcut to close windows) or by the close_tab action. A value of
        # zero disables confirmation. This confirmation also applies to
        # requests to quit the entire application (all OS windows, via the
        # quit action). Negative values are converted to positive ones,
        # however, with shell_integration enabled, using negative values
        # means windows sitting at a shell prompt are not counted, only
        # windows where some command is currently running. You can also have
        # backgrounded jobs prevent closing, by adding count-background to
        # the setting, for example: -1 count-background. Note that if you
        # want confirmation when closing individual windows, you can map the
        # close_window_with_confirmation action.
        confirm_os_window_close = 0;

        # The edge to show the tab bar on, top or bottom.
        #tab_bar_edge = "top";

        # The tab bar style, can be one of:
        # fade
        #     Each tab's edges fade into the background color. (See also tab_fade)
        # slant
        #     Tabs look like the tabs in a physical file.
        # separator
        #     Tabs are separated by a configurable separator. (See also
        #     tab_separator)
        # powerline
        #     Tabs are shown as a continuous line with "fancy" separators.
        #     (See also tab_powerline_style)
        # custom
        #     A user-supplied Python function called draw_tab is loaded from the file
        #     tab_bar.py in the kitty config directory. For examples of how to
        #     write such a function, see the functions named draw_tab_with_* in
        #     kitty's source code: kitty/tab_bar.py. See also
        #     this discussion <https://github.com/kovidgoyal/kitty/discussions/4447>
        #     for examples from kitty users.
        # hidden
        #     The tab bar is hidden. If you use this, you might want to create
        #     a mapping for the select_tab action which presents you with a list of
        #     tabs and allows for easy switching to a tab.
        tab_bar_style = "powerline";

        # The powerline separator style between tabs in the tab bar when
        # using powerline as the tab_bar_style, can be one of: angled,
        # slanted, round.
        tab_powerline_style = "slanted";

        # The minimum number of tabs that must exist before the tab bar is
        # shown.
        tab_bar_min_tabs = 1;

        # A template to render the tab title. The default just renders the
        # title with optional symbols for bell and activity. If you wish to
        # include the tab-index as well, use something like: {index}:{title}.
        # Useful if you have shortcuts mapped for goto_tab N. If you prefer
        # to see the index as a superscript, use {sup.index}. All data
        # available is:
        # title
        #     The current tab title.
        # index
        #     The tab index usable with goto_tab N goto_tab shortcuts.
        #tab_title_template = "{index}:{title}";

        # Modify font characteristics such as the position or thickness of
        # the underline and strikethrough. The modifications can have the
        # suffix px for pixels or % for percentage of original value. No
        # suffix means use pts. For example:
        # modify_font underline_position -2
        # modify_font underline_thickness 150%
        # modify_font strikethrough_thickness 200%
        # modify_font strikethrough_position 2px
        # Additionally, you can modify the size of the cell in which each
        # font glyph is rendered and the baseline at which the glyph is
        # placed in the cell. For example:
        # modify_font cell_width 80%
        # modify_font cell_height -2px
        # modify_font baseline 3
        # Note that modifying the baseline will automatically adjust the
        # underline and strikethrough positions by the same amount.
        # Increasing the baseline raises glyphs inside the cell and
        # decreasing it lowers them. Decreasing the cell size might cause
        # rendering artifacts, so use with care.
        "modify_font cell_height" = "110%";
      };
    };
  };

  config.hm.desktop = { ... }: {
    programs.kitty.font.size = 11;
  };

  config.hm.laptop = { ... }: {
    programs.kitty.font.size = 11.5;
  };
}
