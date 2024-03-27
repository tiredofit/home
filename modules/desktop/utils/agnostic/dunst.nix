{ config, lib, nix-colors, pkgs, ... }:

let
  cfg = config.host.home.applications.dunst;
in
  with lib;
{
  options = {
    host.home.applications.dunst = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Notifications Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.libnotify ];                   # Dependency
    services.dunst = {
      enable = true;
      iconTheme = {                                       # Icons
        name = "Papirus Dark";
        package = pkgs.papirus-icon-theme;
        size = "16x16";
      };
      settings = {               # Settings
        global = {
          monitor = 1;
          follow = "none";
          width = 500 ;
          height = 300 ;
          origin = "top-left" ;
          offset = "30x50" ;

          # Show how many messages are currently hidden (because of geometry).
          indicate_hidden = "yes";

          # Shrink window if it's smaller than the width.  Will be ignored if
          # width is 0.
          shrink = "no";

          # The transparency of the window.  Range: [0; 100].
          # This option will only work if a compositing window manager is
          # present (e.g. xcompmgr, compiz, etc.).
          transparency = 5;

          # The height of the entire notification.  If the height is smaller
          # than the font height and padding combined, it will be raised
          # to the font height and padding.
          #notification_height = 0;

          # Draw a line of "separator_height" pixel height between two
          # notifications.
          # Set to 0 to disable.
          separator_height = 2;

          # Padding between text and separator.
          padding = 6;

          # Horizontal padding.
          horizontal_padding = 6;

          # Defines width in pixels of frame around the notification window.
          # Set to 0 to disable.
          frame_width = 3;

          # Defines color of the frame around the notification window.
          frame_color = "#343D46";

          # Define a color for the separator.
          # possible values are:
          #  * auto: dunst tries to find a color fitting to the background;
          #  * foreground: use the same color as the foreground;
          #  * frame: use the same color as the frame;
          #  * anything else will be interpreted as a X color.
          #separator_color = "frame";
          separator_color = "auto";

          # Sort messages by urgency.
          sort = "yes";

          # Don't remove messages, if the user is idle (no mouse or keyboard input)
          # for longer than idle_threshold seconds.
          # Set to 0 to disable.
          # Transient notifications ignore this setting.
          idle_threshold = 0;

          font = "Hack Nerd Font 10";
          line_height = 3;

          ### Progress bar ###

          # Turn on the progess bar. It appears when a progress hint is passed with
          # for example dunstify -h int:value:12
          progress_bar = true;

          # Set the progress bar height. This includes the frame, so make sure
          # it's at least twice as big as the frame width.
          progress_bar_height = 10;

          # Set the frame width of the progress bar
          progress_bar_frame_width = 1;

          # Set the minimum width for the progress bar
          progress_bar_min_width = 150;

          # Set the maximum width for the progress bar
          progress_bar_max_width = 500;
          # Possible values are:
          # full: Allow a small subset of html markup in notifications:
          #        <b>bold</b>
          #        <i>italic</i>
          #        <s>strikethrough</s>
          #        <u>underline</u>
          #
          #        For a complete reference see
          #        <http://developer.gnome.org/pango/stable/PangoMarkupFormat.html>.
          #
          # strip: This setting is provided for compatibility with some broken
          #        clients that send markup even though it's not enabled on the
          #        server. Dunst will try to strip the markup but the parsing is
          #        simplistic so using this option outside of matching rules for
          #        specific applications *IS GREATLY DISCOURAGED*.
          #
          # no:    Disable markup parsing, incoming notifications will be treated as
          #        plain text. Dunst will not advertise that it has the body-markup
          #        capability if this is set as a global setting.
          #
          # It's important to note that markup inside the format option will be parsed
          # regardless of what this is set to.
          markup = "full";

          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          #   %n  progress value if set without any extra characters
          #   %%  Literal %
          # Markup is allowed
          format = ''<b>%s</b>\n%b'';

          # Alignment of message text.
          # Possible values are "left", "center" and "right".
          alignment = "left";

          # Show age of message if message is older than show_age_threshold
          # seconds.
          # Set to -1 to disable.
          show_age_threshold = 60 ;

          # Split notifications into multiple lines if they don't fit into
          # geometry.
          word_wrap = "yes";

          # When word_wrap is set to no, specify where to ellipsize long lines.
          # Possible values are "start", "middle" and "end".
          ellipsize = "middle";

          # Ignore newlines '\n' in notifications.
          ignore_newline = "no" ;

          # Merge multiple notifications with the same content
          stack_duplicates = true;

          # Hide the count of merged notifications with the same content
          hide_duplicate_count = false;

          # Display indicators for URLs (U) and actions (A).
          show_indicators = "yes";

          ### Icons ###

          # Align icons left/right/off
          icon_position = "left";

          # Scale larger icons down to this size, set to 0 to disable
          max_icon_size = 78;

          ### History ###

          # Should a notification popped up from history be sticky or timeout
          # as if it would normally do.
          sticky_history = "yes";

          # Maximum amount of notifications kept in history
          history_length = "20";

          ### Misc/Advanced ###

          # dmenu path.
          #dmenu = /usr/bin/dmenu -p dunst:

          # Browser for opening urls in context menu.
          browser = "firefox -new-tab";

          # Always run rule-defined scripts, even if the notification is suppressed
          always_run_script = true ;

          # Define the title of the windows spawned by dunst
          title = "Dunst";

          # Define the class of the windows spawned by dunst
          class = "Dunst";

          # Print a notification on startup.
          # This is mainly for error detection, since dbus (re-)starts dunst
          # automatically after a crash.
          #startup_notification = true;

          ### Legacy

          # Use the Xinerama extension instead of RandR for multi-monitor support.
          # This setting is provided for compatibility with older nVidia drivers that
          # do not support RandR and using it on systems that support RandR is highly
          # discouraged.
          #
          # By enabling this setting dunst will not be able to detect when a monitor
          # is connected or disconnected which might break follow mode if the screen
          # layout changes.
          force_xinerama = false;
        };

        experimental = {
          per_monitor_dpi = false;
        };

        urgency_low = {
            # IMPORTANT: colors have to be defined in quotation marks.
            # Otherwise the "#" and following would be interpreted as a comment.
            background = "#${config.colorscheme.colors.base06}" ;
            foreground = "#${config.colorscheme.colors.base02}" ;
            timeout = 10 ;
            # Icon for notifications with low urgency, uncomment to enable
            #icon = /path/to/icon
        };

        urgency_normal = {
            background = "#${config.colorscheme.colors.base06}" ;
            foreground = "#${config.colorscheme.colors.base02}" ;
            timeout = 10 ;
            # Icon for notifications with normal urgency, uncomment to enable
            #icon = /path/to/icon
        };

        urgency_critical = {
            background = "#${config.colorscheme.colors.base00}" ;
            foreground = "#${config.colorscheme.colors.base06}" ;
            frame_color = "#${config.colorscheme.colors.base0F}" ;
            timeout = 0 ;
            # Icon for notifications with critical urgency, uncomment to enable
            #icon = /path/to/icon
        };
      };
    #xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";
    };
  };
}
