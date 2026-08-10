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
          numlock = null;
        };

        touchpad = {
          tap = null;
          natural-scroll = null;
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

        # When to center a column when changing focus, options are:
        # - "never", default behavior, focusing an off-screen column will keep at the left
        #   or right edge of the screen.
        # - "always", the focused column will always be centered.
        # - "on-overflow", focusing a column will center it if it doesn't fit
        #   together with the previously focused column.
        center-focused-column = "never";

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

          # Color of the ring on the active monitor.
          active-color = "#59c2ff";

          # Color of the ring on inactive monitors.
          inactive-color = "#3e4b59";
        };

        # You can also add a border. It's similar to the focus ring, but always visible.
        border = {
          # The settings are the same as for the focus ring.
          # If you enable the border, you probably want to disable the focus ring.
          off = null;

          width = 4;
          active-color = "#ff8f40";
          inactive-color = "#3e4b59";

          # Color of the border around windows that request your attention.
          urgent-color = "#f07178";
        };

        # You can enable drop shadows for windows.
        shadow = {
          # Softness controls the shadow blur radius.
          softness = 30;

          # Spread expands the shadow.
          spread = 5;

          # Offset moves the shadow relative to the window.
          offset._attrs = {
            x = 0;
            y = 5;
          };

          color = "#0007";
        };
      };

      xwayland-satellite.path = lib.getExe config.pkgs.xwayland-satellite;

      # Add lines like this to spawn processes at startup.
      spawn-at-startup = [
        noctalia
      ];

      # Uncomment this line to ask the clients to omit their client-side decorations if possible.
      # prefer-no-csd = null;

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
      gestures.hot-corners.off = null;

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
        "Mod+Shift+Slash".show-hotkey-overlay = null;

        # Suggested binds for running programs: terminal, app launcher, screen locker.
        "Mod+T".spawn = config.terminal;
        "Mod+D".spawn-sh = "${noctalia} ipc call launcher toggle";
        "Super+Alt+L".spawn-sh = "${noctalia} ipc call lockScreen lock";

        # Example volume keys mappings for PipeWire & WirePlumber.
        # The allow-when-locked=true property makes them work even when the session is locked.
        # "-l 1.0" limits the volume to 100%.
        "XF86AudioRaiseVolume" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        };
        "XF86AudioLowerVolume" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };
        "XF86AudioMute" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # Example media keys mapping using playerctl.
        # This will work with any MPRIS-enabled media player.
        "XF86AudioPlay" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "playerctl play-pause";
        };
        "XF86AudioPause" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "playerctl play-pause";
        };
        "XF86AudioStop" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "playerctl stop";
        };
        "XF86AudioPrev" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "playerctl previous";
        };
        "XF86AudioNext" = {
          _attrs.allow-when-locked = true;
          spawn-sh = "playerctl next";
        };

        # Example brightness key mappings for brightnessctl.
        "XF86MonBrightnessUp" = {
          _attrs.allow-when-locked = true;
          spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
        };
        "XF86MonBrightnessDown" = {
          _attrs.allow-when-locked = true;
          spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
        };

        # Open/close the Overview: a zoomed-out view of workspaces and windows.
        # You can also move the mouse into the top-left hot corner,
        # or do a four-finger swipe up on a touchpad.
        "Mod+O" = {
          _attrs.repeat = false;
          toggle-overview = null;
        };

        "Mod+Q" = {
          _attrs.repeat = false;
          close-window = null;
        };

        "Mod+Left".focus-column-left = null;
        "Mod+Down".focus-window-down = null;
        "Mod+Up".focus-window-up = null;
        "Mod+Right".focus-column-right = null;
        "Mod+H".focus-column-left = null;
        "Mod+J".focus-window-down = null;
        "Mod+K".focus-window-up = null;
        "Mod+L".focus-column-right = null;

        "Mod+Ctrl+Left".move-column-left = null;
        "Mod+Ctrl+Down".move-window-down = null;
        "Mod+Ctrl+Up".move-window-up = null;
        "Mod+Ctrl+Right".move-column-right = null;
        "Mod+Ctrl+H".move-column-left = null;
        "Mod+Ctrl+J".move-window-down = null;
        "Mod+Ctrl+K".move-window-up = null;
        "Mod+Ctrl+L".move-column-right = null;

        "Mod+Home".focus-column-first = null;
        "Mod+End".focus-column-last = null;
        "Mod+Ctrl+Home".move-column-to-first = null;
        "Mod+Ctrl+End".move-column-to-last = null;

        "Mod+Shift+Left".focus-monitor-left = null;
        "Mod+Shift+Down".focus-monitor-down = null;
        "Mod+Shift+Up".focus-monitor-up = null;
        "Mod+Shift+Right".focus-monitor-right = null;
        "Mod+Shift+H".focus-monitor-left = null;
        "Mod+Shift+J".focus-monitor-down = null;
        "Mod+Shift+K".focus-monitor-up = null;
        "Mod+Shift+L".focus-monitor-right = null;

        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = null;
        "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = null;
        "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = null;
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = null;
        "Mod+Shift+Ctrl+H".move-column-to-monitor-left = null;
        "Mod+Shift+Ctrl+J".move-column-to-monitor-down = null;
        "Mod+Shift+Ctrl+K".move-column-to-monitor-up = null;
        "Mod+Shift+Ctrl+L".move-column-to-monitor-right = null;

        "Mod+Page_Down".focus-workspace-down = null;
        "Mod+Page_Up".focus-workspace-up = null;
        "Mod+U".focus-workspace-down = null;
        "Mod+I".focus-workspace-up = null;
        "Mod+Ctrl+Page_Down".move-column-to-workspace-down = null;
        "Mod+Ctrl+Page_Up".move-column-to-workspace-up = null;
        "Mod+Ctrl+U".move-column-to-workspace-down = null;
        "Mod+Ctrl+I".move-column-to-workspace-up = null;

        "Mod+Shift+Page_Down".move-workspace-down = null;
        "Mod+Shift+Page_Up".move-workspace-up = null;
        "Mod+Shift+U".move-workspace-down = null;
        "Mod+Shift+I".move-workspace-up = null;

        # You can bind mouse wheel scroll ticks using the following syntax.
        # These binds will change direction based on the natural-scroll setting.
        #
        # To avoid scrolling through workspaces really fast, you can use
        # the cooldown-ms property. The bind will be rate-limited to this value.
        # You can set a cooldown on any bind, but it's most useful for the wheel.
        "Mod+WheelScrollDown" = {
          _attrs.cooldown-ms = 150;
          focus-workspace-down = null;
        };
        "Mod+WheelScrollUp" = {
          _attrs.cooldown-ms = 150;
          focus-workspace-up = null;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          _attrs.cooldown-ms = 150;
          move-column-to-workspace-down = null;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          _attrs.cooldown-ms = 150;
          move-column-to-workspace-up = null;
        };

        "Mod+WheelScrollRight".focus-column-right = null;
        "Mod+WheelScrollLeft".focus-column-left = null;
        "Mod+Ctrl+WheelScrollRight".move-column-right = null;
        "Mod+Ctrl+WheelScrollLeft".move-column-left = null;

        # Usually scrolling up and down with Shift in applications results in
        # horizontal scrolling; these binds replicate that.
        "Mod+Shift+WheelScrollDown".focus-column-right = null;
        "Mod+Shift+WheelScrollUp".focus-column-left = null;
        "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = null;
        "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = null;

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
        "Mod+BracketLeft".consume-or-expel-window-left = null;
        "Mod+BracketRight".consume-or-expel-window-right = null;

        # Consume one window from the right to the bottom of the focused column.
        "Mod+Comma".consume-window-into-column = null;
        # Expel the bottom window from the focused column to the right.
        "Mod+Period".expel-window-from-column = null;

        # Cycle through widths set in preset-column-widths.
        "Mod+R".switch-preset-column-width = null;
        # Cycling through the presets in reverse order is also possible.
        "Mod+Shift+R".switch-preset-column-width-back = null;

        "Mod+Ctrl+Shift+R".switch-preset-window-height = null;
        "Mod+Ctrl+R".reset-window-height = null;

        "Mod+F".maximize-column = null;
        "Mod+Shift+F".fullscreen-window = null;

        # While maximize-column leaves gaps and borders around the window,
        # maximize-window-to-edges doesn't: the window expands to the edges of the screen.
        "Mod+M".maximize-window-to-edges = null;

        # Expand the focused column to space not taken up by other fully visible columns.
        "Mod+Ctrl+F".expand-column-to-available-width = null;

        "Mod+C".center-column = null;

        # Center all fully visible columns on screen.
        "Mod+Ctrl+C".center-visible-columns = null;

        # Finer width adjustments.
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";

        # Finer height adjustments when in column with other windows.
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        # Move the focused window between the floating and the tiling layout.
        "Mod+V".toggle-window-floating = null;
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;

        # Toggle tabbed column display mode.
        # Windows in this column will appear as vertical tabs,
        # rather than stacked on top of each other.
        "Mod+W".toggle-column-tabbed-display = null;

        "Print".screenshot = null;
        "Ctrl+Print".screenshot-screen = null;
        "Alt+Print".screenshot-window = null;

        # Applications such as remote-desktop clients and software KVM switches may
        # request that niri stops processing the keyboard shortcuts defined here
        # so they may, for example, forward the key presses as-is to a remote machine.
        # It's a good idea to bind an escape hatch to toggle the inhibitor,
        # so a buggy application can't hold your session hostage.
        "Mod+Escape" = {
          _attrs.allow-inhibiting = false;
          toggle-keyboard-shortcuts-inhibit = null;
        };

        # The quit action will show a confirmation dialog to avoid accidental exits.
        "Mod+Shift+E".quit = null;
        "Ctrl+Alt+Delete".quit = null;

        # Powers off the monitors. To turn them back on, do any input like
        # moving the mouse or pressing any other key.
        "Mod+Shift+P".power-off-monitors = null;
      };
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
