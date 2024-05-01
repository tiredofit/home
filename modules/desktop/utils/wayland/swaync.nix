{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.sway-notification-center;
in
  with lib;
{
  options = {
    host.home.applications.sway-notification-center = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Notification Center for Wayland";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swaynotificationcenter
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "swaync"
        ];
      };
    };

    xdg.configFile."swaync/config.json".text = ''
      {
        "positionX": "right",
        "positionY": "top",
        "layer": "overlay",
        "layer-shell": true,
        "cssPriority": "user",
        "control-center-layer": "top",
        "control-center-positionX": "none",
        "control-center-positionY": "none",
        "control-center-margin-top": 0,
        "control-center-margin-bottom": 0,
        "control-center-margin-right": 0,
        "control-center-margin-left": 0,
        "control-center-width": 600,
        "control-center-height": 600,
        "control-center-exclusive-zone": true,
        "notification-2fa-action": true,
        "notification-inline-replies": true,
        "notification-icon-size": 64,
        "notification-body-image-height": 100,
        "notification-body-image-width": 200,
        "notification-window-width": 600,
        "notification-window-height": 100,
        "timeout": 10,
        "timeout-low": 5,
        "timeout-critical": 0,
        "fit-to-screen": true,
        "relative-timestamps": true,
        "keyboard-shortcuts": true,
        "image-visibility": "when-available",
        "transition-time": 200,
        "hide-on-clear": true,
        "hide-on-action": true,
        "script-fail-notify": false,
        "widgets": [
          "title",
          "dnd",
          "notifications"
        ],
        "widget-config": {
          "title": {
            "text": "Notifications",
            "clear-all-button": true,
            "button-text": "Clear All"
          },
          "dnd": {
            "text": "Do Not Disturb"
          }
        }
      }
    '';

    xdg.configFile."swaync/style.css".text = ''
      /*
      :root {
        --base: #191724;
        --surface: #1f1d2e;
        --overlay: #26233a;
        --muted: #6e6a86;
        --subtle: #908caa;
        --text: #e0def4;
        --love: #eb6f92;
        --gold: #f6c177;
        --rose: #ebbcba;
        --pine: #31748f;
        --foam: #9ccfd8;
        --iris: #c4a7e7;
        --highlightLow: #21202e;
        --highlightMed: #403d52;
        --highlightHigh: #524f67;
      }
      */
      *
      {
      	all:unset;
      	font-family:Noto Sans NF;
      	transition:.3s;
      	font-size:1rem
      }

      .floating-notifications.background .notification-row
      {
      	padding:1rem
      }

      .floating-notifications.background .notification-row .notification-background
      {
      	border-radius:.5rem;
      	background-color:#191724;
      	color:#e0def4;
      	border:1px solid #6e6a86
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      {
      	padding:.5rem;
      	border-radius:.5rem
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification.critical
      {
      	border:1px solid #eb6f92
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      .notification-content
      .summary
      {
      	margin:.5rem;
      	color:#e0def4;
      	font-weight:700
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      .notification-content
      .body
      {
      	margin:.5rem;
      	color:#908caa
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      {
      	min-height:3rem
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action
      {
      	border-radius:.5rem;
      	color:#e0def4;
      	background-color:#1f1d2e;
      	border:1px solid #6e6a86
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action:hover
      {
      	background-color:#26233a
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action:active
      {
      	background-color:#6e6a86
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .close-button
      {
      	margin:.5rem;
      	padding:.25rem;
      	border-radius:.5rem;
      	color:#e0def4;
      	background-color:#eb6f92
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .close-button:hover
      {
      	color:#191724
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .close-button:active
      {
      	background-color:#ebbcba
      }

      .control-center
      {
      	border-radius:.5rem;
      	margin:1rem;
      	background-color:#191724;
      	color:#e0def4;
      	padding:1rem;
      	border:1px solid #6e6a86
      }

      .control-center .widget-title
      {
      	color:#ebbcba;
      	font-weight:700
      }

      .control-center .widget-title button
      {
      	border-radius:.5rem;
      	color:#e0def4;
      	background-color:#1f1d2e;
      	border:1px solid #6e6a86;
      	padding:.5rem
      }

      .control-center .widget-title button:hover
      {
      	background-color:#26233a
      }

      .control-center .widget-title button:active
      {
      	background-color:#6e6a86
      }

      .control-center .notification-row .notification-background
      {
      	border-radius:.5rem;
      	margin:.5rem 0;
      	background-color:#1f1d2e;
      	color:#e0def4;
      	border:1px solid #6e6a86
      }

      .control-center .notification-row .notification-background .notification
      {
      	padding:.5rem;
      	border-radius:.5rem
      }

      .control-center
      .notification-row
      .notification-background
      .notification.critical
      {
      	border:1px solid #eb6f92
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      {
      	color:#e0def4
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      .summary
      {
      	margin:.5rem;
      	color:#cdd6f4;
      	font-weight:700
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      .body
      {
      	margin:.5rem;
      	color:#908caa
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      {
      	min-height:3rem
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action
      {
      	border-radius:.5rem;
      	color:#e0def4;
      	background-color:#1f1d2e;
      	border:1px solid #6e6a86
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action:hover
      {
      	background-color:#26233a
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      > :last-child
      > *
      .notification-action:active
      {
      	background-color:#6e6a86
      }

      .control-center .notification-row .notification-background .close-button
      {
      	margin:.5rem;
      	padding:.25rem;
      	border-radius:.5rem;
      	color:#e0def4;
      	background-color:#eb6f92
      }

      .control-center .notification-row .notification-background .close-button:hover
      {
      	color:#191724
      }

      .control-center
      .notification-row
      .notification-background
      .close-button:active
      {
      	background-color:#ebbcba
      }

      progressbar,progress,trough
      {
      	border-radius:.5rem
      }

      .notification.critical progress
      {
      	background-color:#f38ba8
      }

      .notification.low progress,.notification.normal progress
      {
      	background-color:#89b4fa
      }

      trough
      {
      	background-color:#313244
      }

      .control-center trough
      {
      	background-color:#45475a
      }

      .control-center-dnd
      {
      	margin:1rem 0;
      	border-radius:.5rem
      }

      .control-center-dnd slider
      {
      	background:#26233a;
      	border-radius:.5rem
      }

      .widget-dnd
      {
      	color:#908caa
      }

      .widget-dnd > switch
      {
      	border-radius:.5rem;
      	background:#26233a;
      	border:1px solid #6e6a86
      }

      .widget-dnd > switch:checked slider
      {
      	background:#31748f
      }

      .widget-dnd > switch slider
      {
      	background:#6e6a86;
      	border-radius:.5rem;
      	margin:.25rem
      }
    '';
  };
}
