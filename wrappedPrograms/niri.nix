{
  self,
  inputs,
  ...
}: {
  # Transcription of niri's shipped default config
  # (resources/default-config.kdl) into the wrapper's attrset form.
  # Check the wiki for a full description of the configuration:
  # https://niri-wm.github.io/niri/Configuration:-Introduction
  flake.wrappersModules.niri = {
    config,
    lib,
    ...
  }: {
    options.terminal = lib.mkOption {
      type = lib.types.str;
      default = "alacritty";
    };

    config.settings = let
      noctalia = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia-shell;
    in {
      # Input device configuration.
      # Find the full list of options on the wiki:
      # https://niri-wm.github.io/niri/Configuration:-Input
      input = {
        keyboard = {
          # If this section is empty, niri will fetch xkb settings
          # from org.freedesktop.locale1. You can control these using
          # localectl set-x11-keymap.
          xkb = {};

          # Enable numlock on startup, omitting this setting disables it.
          numlock = _: {};
        };

        touchpad = {
          tap = _: {};
          natural-scroll = _: {};
        };
      };

      # You can configure outputs by their name, which you can find
      # by running `niri msg outputs` while inside a niri instance.
      # The built-in laptop monitor is usually called "eDP-1".
      # https://niri-wm.github.io/niri/Configuration:-Outputs
      outputs = {};

      # Settings that influence how windows are positioned and sized.
      # https://niri-wm.github.io/niri/Configuration:-Layout
      layout = {
        # Set gaps around windows in logical pixels.
        gaps = 16;

        # You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];

        # You can change the default width of the new windows.
        default-column-width.proportion = 0.5;

        # You can change how the focus ring looks.
        focus-ring = {
          # How many logical pixels the ring extends out from the windows.
          width = 4;
        };

        # You can also add a border. It's similar to the focus ring, but always visible.
        border = {
          # The settings are the same as for the focus ring.
          # If you enable the border, you probably want to disable the focus ring.
          off = _: {};

          width = 4;
        };

        # You can enable drop shadows for windows.
        shadow = {
          # Softness controls the shadow blur radius.
          softness = 30;

          # Spread expands the shadow.
          spread = 5;

          # Offset moves the shadow relative to the window.
          offset = _: {
            props = {
              x = 0;
              y = 5;
            };
          };

          color = "#0007";
        };
      };

      xwayland-satellite.path = lib.getExe config.pkgs.xwayland-satellite;

      hotkey-overlay = {
        # Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
        skip-at-startup = _: {};
      };

      # Uncomment this line to ask the clients to omit their client-side decorations if possible.
      # prefer-no-csd = _: {};

      # You can change the path where screenshots are saved.
      # A ~ at the front will be expanded to the home directory.
      # The path is formatted with strftime(3) to give you the screenshot date and time.
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # The wiki explains how to configure individual animations:
      # https://niri-wm.github.io/niri/Configuration:-Animations
      animations = {};

      # Hot corners let you toggle the overview by putting your mouse at a
      # corner of a monitor.
      # https://niri-wm.github.io/niri/Configuration:-Gestures
      gestures.hot-corners.top-left = _: {};

      # Change the theme and size of the cursor as well as set the
      # XCURSOR_THEME and XCURSOR_SIZE environment variables.
      # https://niri-wm.github.io/niri/Configuration:-Miscellaneous
      cursor = {
        xcursor-theme = "Adwaita";
        xcursor-size = 24;
      };

      # Window rules let you adjust behavior for individual windows.
      # https://niri-wm.github.io/niri/Configuration:-Window-Rules
      window-rules = [
        # Work around WezTerm's initial configure bug
        # by setting an empty default-column-width.
        {
          matches = [{app-id = "wezterm";}];
          default-column-width = {};
        }

        # Open the Firefox picture-in-picture player as floating by default.
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
      ];

      # Layer rules let you adjust behavior for individual layer-shell surfaces.
      # https://niri-wm.github.io/niri/Configuration:-Layer-Rules
      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview";}];
          place-within-backdrop = true;
        }
      ];

      binds = {
        # Keys consist of modifiers separated by + signs, followed by an XKB key name
        # in the end. To find an XKB name for a particular key, you may use a program
        # like wev.
        #
        # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
        # when running as a winit window.
        #
        # Most actions that you can bind here can also be invoked programmatically with
        # `niri msg action do-something`.

        # Mod-Shift-/, which is usually the same as Mod-?,
        # shows a list of important hotkeys.
        "Mod+Shift+Slash".show-hotkey-overlay = _: {};

        # Suggested binds for running programs: terminal, app launcher, screen locker.
        "Mod+T".spawn = config.terminal;
        "Mod+D".spawn-sh = "${noctalia} ipc call launcher toggle";
        "Super+Alt+L".spawn-sh = "${noctalia} ipc call lockScreen lock";

        # Example volume keys mappings for PipeWire & WirePlumber.
        # The allow-when-locked=true property makes them work even when the session is locked.
        # "-l 1.0" limits the volume to 100%.
        "XF86AudioRaiseVolume" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        };
        "XF86AudioLowerVolume" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };
        "XF86AudioMute" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # Example media keys mapping using playerctl.
        # This will work with any MPRIS-enabled media player.
        "XF86AudioPlay" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "playerctl play-pause";
        };
        "XF86AudioPause" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "playerctl play-pause";
        };
        "XF86AudioStop" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "playerctl stop";
        };
        "XF86AudioPrev" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "playerctl previous";
        };
        "XF86AudioNext" = _: {
          props.allow-when-locked = true;
          content.spawn-sh = "playerctl next";
        };

        # Example brightness key mappings for brightnessctl.
        "XF86MonBrightnessUp" = _: {
          props.allow-when-locked = true;
          content.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
        };
        "XF86MonBrightnessDown" = _: {
          props.allow-when-locked = true;
          content.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
        };

        # Open/close the Overview: a zoomed-out view of workspaces and windows.
        # You can also move the mouse into the top-left hot corner,
        # or do a four-finger swipe up on a touchpad.
        "Mod+O" = _: {
          props.repeat = false;
          content.toggle-overview = _: {};
        };

        "Mod+Q" = _: {
          props.repeat = false;
          content.close-window = _: {};
        };

        "Mod+Left".focus-column-left = _: {};
        "Mod+Down".focus-window-down = _: {};
        "Mod+Up".focus-window-up = _: {};
        "Mod+Right".focus-column-right = _: {};
        "Mod+H".focus-column-left = _: {};
        "Mod+J".focus-window-down = _: {};
        "Mod+K".focus-window-up = _: {};
        "Mod+L".focus-column-right = _: {};

        "Mod+Ctrl+Left".move-column-left = _: {};
        "Mod+Ctrl+Down".move-window-down = _: {};
        "Mod+Ctrl+Up".move-window-up = _: {};
        "Mod+Ctrl+Right".move-column-right = _: {};
        "Mod+Ctrl+H".move-column-left = _: {};
        "Mod+Ctrl+J".move-window-down = _: {};
        "Mod+Ctrl+K".move-window-up = _: {};
        "Mod+Ctrl+L".move-column-right = _: {};

        "Mod+Home".focus-column-first = _: {};
        "Mod+End".focus-column-last = _: {};
        "Mod+Ctrl+Home".move-column-to-first = _: {};
        "Mod+Ctrl+End".move-column-to-last = _: {};

        "Mod+Shift+Left".focus-monitor-left = _: {};
        "Mod+Shift+Down".focus-monitor-down = _: {};
        "Mod+Shift+Up".focus-monitor-up = _: {};
        "Mod+Shift+Right".focus-monitor-right = _: {};
        "Mod+Shift+H".focus-monitor-left = _: {};
        "Mod+Shift+J".focus-monitor-down = _: {};
        "Mod+Shift+K".focus-monitor-up = _: {};
        "Mod+Shift+L".focus-monitor-right = _: {};

        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: {};
        "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = _: {};
        "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = _: {};
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: {};
        "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: {};
        "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: {};
        "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: {};
        "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: {};

        "Mod+Page_Down".focus-workspace-down = _: {};
        "Mod+Page_Up".focus-workspace-up = _: {};
        "Mod+U".focus-workspace-down = _: {};
        "Mod+I".focus-workspace-up = _: {};
        "Mod+Ctrl+Page_Down".move-column-to-workspace-down = _: {};
        "Mod+Ctrl+Page_Up".move-column-to-workspace-up = _: {};
        "Mod+Ctrl+U".move-column-to-workspace-down = _: {};
        "Mod+Ctrl+I".move-column-to-workspace-up = _: {};

        "Mod+Shift+Page_Down".move-workspace-down = _: {};
        "Mod+Shift+Page_Up".move-workspace-up = _: {};
        "Mod+Shift+U".move-workspace-down = _: {};
        "Mod+Shift+I".move-workspace-up = _: {};

        # You can bind mouse wheel scroll ticks using the following syntax.
        # These binds will change direction based on the natural-scroll setting.
        #
        # To avoid scrolling through workspaces really fast, you can use
        # the cooldown-ms property. The bind will be rate-limited to this value.
        # You can set a cooldown on any bind, but it's most useful for the wheel.
        "Mod+WheelScrollDown" = _: {
          props.cooldown-ms = 150;
          content.focus-workspace-down = _: {};
        };
        "Mod+WheelScrollUp" = _: {
          props.cooldown-ms = 150;
          content.focus-workspace-up = _: {};
        };
        "Mod+Ctrl+WheelScrollDown" = _: {
          props.cooldown-ms = 150;
          content.move-column-to-workspace-down = _: {};
        };
        "Mod+Ctrl+WheelScrollUp" = _: {
          props.cooldown-ms = 150;
          content.move-column-to-workspace-up = _: {};
        };

        "Mod+WheelScrollRight".focus-column-right = _: {};
        "Mod+WheelScrollLeft".focus-column-left = _: {};
        "Mod+Ctrl+WheelScrollRight".move-column-right = _: {};
        "Mod+Ctrl+WheelScrollLeft".move-column-left = _: {};

        # Usually scrolling up and down with Shift in applications results in
        # horizontal scrolling; these binds replicate that.
        "Mod+Shift+WheelScrollDown".focus-column-right = _: {};
        "Mod+Shift+WheelScrollUp".focus-column-left = _: {};
        "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = _: {};
        "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = _: {};

        # You can refer to workspaces by index. However, keep in mind that
        # niri is a dynamic workspace system, so these commands are kind of
        # "best effort". Trying to refer to a workspace index bigger than
        # the current workspace count will instead refer to the bottommost
        # (empty) workspace.
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;
        "Mod+Ctrl+1".move-column-to-workspace = 1;
        "Mod+Ctrl+2".move-column-to-workspace = 2;
        "Mod+Ctrl+3".move-column-to-workspace = 3;
        "Mod+Ctrl+4".move-column-to-workspace = 4;
        "Mod+Ctrl+5".move-column-to-workspace = 5;
        "Mod+Ctrl+6".move-column-to-workspace = 6;
        "Mod+Ctrl+7".move-column-to-workspace = 7;
        "Mod+Ctrl+8".move-column-to-workspace = 8;
        "Mod+Ctrl+9".move-column-to-workspace = 9;

        # The following binds move the focused window in and out of a column.
        # If the window is alone, they will consume it into the nearby column to the side.
        # If the window is already in a column, they will expel it out.
        "Mod+BracketLeft".consume-or-expel-window-left = _: {};
        "Mod+BracketRight".consume-or-expel-window-right = _: {};

        # Consume one window from the right to the bottom of the focused column.
        "Mod+Comma".consume-window-into-column = _: {};
        # Expel the bottom window from the focused column to the right.
        "Mod+Period".expel-window-from-column = _: {};

        # Cycle through widths set in preset-column-widths.
        "Mod+R".switch-preset-column-width = _: {};
        # Cycling through the presets in reverse order is also possible.
        "Mod+Shift+R".switch-preset-column-width-back = _: {};

        "Mod+Ctrl+Shift+R".switch-preset-window-height = _: {};
        "Mod+Ctrl+R".reset-window-height = _: {};

        "Mod+F".maximize-column = _: {};
        "Mod+Shift+F".fullscreen-window = _: {};

        # While maximize-column leaves gaps and borders around the window,
        # maximize-window-to-edges doesn't: the window expands to the edges of the screen.
        "Mod+M".maximize-window-to-edges = _: {};

        # Expand the focused column to space not taken up by other fully visible columns.
        "Mod+Ctrl+F".expand-column-to-available-width = _: {};

        "Mod+C".center-column = _: {};

        # Center all fully visible columns on screen.
        "Mod+Ctrl+C".center-visible-columns = _: {};

        # Finer width adjustments.
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";

        # Finer height adjustments when in column with other windows.
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        # Move the focused window between the floating and the tiling layout.
        "Mod+V".toggle-window-floating = _: {};
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};

        # Toggle tabbed column display mode.
        # Windows in this column will appear as vertical tabs,
        # rather than stacked on top of each other.
        "Mod+W".toggle-column-tabbed-display = _: {};

        "Print".screenshot = _: {};
        "Ctrl+Print".screenshot-screen = _: {};
        "Alt+Print".screenshot-window = _: {};

        # Applications such as remote-desktop clients and software KVM switches may
        # request that niri stops processing the keyboard shortcuts defined here
        # so they may, for example, forward the key presses as-is to a remote machine.
        # It's a good idea to bind an escape hatch to toggle the inhibitor,
        # so a buggy application can't hold your session hostage.
        "Mod+Escape" = _: {
          props.allow-inhibiting = false;
          content.toggle-keyboard-shortcuts-inhibit = _: {};
        };

        # The quit action will show a confirmation dialog to avoid accidental exits.
        "Mod+Shift+E".quit = _: {};
        "Ctrl+Alt+Delete".quit = _: {};

        # Powers off the monitors. To turn them back on, do any input like
        # moving the mouse or pressing any other key.
        "Mod+Shift+P".power-off-monitors = _: {};

        # For presentations it can be useful to mirror an output to another.
        # Currently, niri doesn't have built-in output mirroring, but you can
        # use a third-party tool wl-mirror that mirrors an output to a window.
        # https://niri-wm.github.io/niri/Screencasting.html
        "Mod+P" = _: {
          props.repeat = false;
          content.spawn-sh = "wl-mirror $(niri msg --json focused-output | jq -r .name)";
        };
      };

      extraConfig = ''
        include optional=true "~/.config/niri/noctalia.kdl"
      '';
    };
  };

  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
      terminal = lib.getExe self'.packages.terminal;
      # Required when used as a session package (services.displayManager).
      passthru.providedSessions = pkgs.niri.passthru.providedSessions;
    };
  };
}
