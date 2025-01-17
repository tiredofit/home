{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) role;
  cfg = config.host.home.applications.hypridle;

  hypridle-companion-script = pkgs.writeShellScriptBin "hypridle-companion" ''
    _hypridle_logfile="$HOME/lock.log"
    HYPRIDLE_DEBUG=''${HYPRIDLE_DEBUG:-"FALSE"}

    _hypridle_gamma() {
        case "$1" in
            get )
                busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature > "$XDG_RUNTIME_DIR"/gamma.temp
            ;;
            set )
                busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature > "$(cat "$XDG_RUNTIME_DIR"/gamma.temp)"
            ;;
        esac
    }

    _hypridle_exec() {
        if [ "''${HYPRIDLE_DEBUG,,}" = "true" ]; then
            "$@" >> "$_hypridle_logfile"
        else
            "$@"
        fi
    }

    _hypridle_log() {
        if [ "''${HYPRIDLE_DEBUG,,}" = "true" ]; then
            echo "$@"  >> "$_hypridle_logfile"
        else
            echo "$@"
        fi
    }

    case "$1" in
        display )
            case "$2" in
                blank )
                    case "$3" in
                        before )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [display] [blank] [timeout] 'hyprctl dispatch dpms off'"
                            _hypridle_gamma set
                            _hypridle_exec hyprctl dispatch dpms off
                        ;;
                        after )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [display] [blank] [resume] 'hyprctl dispatch dpms on'"
                            _hypridle_exec hyprctl dispatch dpms on
                            _hypridle_gamma get
                        ;;
                    esac
                ;;
                dim )
                    _backlight_device=''${_backlight_device:-"$(light -L | grep "backlight/auto")"}
                    _backlight_dim_value=''${4:-".9"}
                    case "$3" in
                        save )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [display] [dim] [timeout] 'save existing display backlight brightness'"
                            _hypridle_exec light -s ''${_backlight_device} -O
                        ;;
                        before )
                            if [ "$5" = "battery" ] ; then
                                if acpi -a | grep "off-line" ; then
                                    dim=true
                                else
                                    dim=false
                                fi
                            else
                                dim=true
                            fi

                            if [ "$dim" = "true" ]; then
                                _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [display] [dim] [timeout] 'dimming display backlight brightness by ''${_backlight_dim_value}'"
                                _hypridle_exec light -s ''${_backlight_device} -T ''${_backlight_dim_value}
                            fi
                        ;;
                        after )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [display] [dim] [timeout] 'restore original display backlight brightness'"
                            _hypridle_exec light -s ''${_backlight_device} -I
                        ;;
                    esac
            esac
        ;;
        keyboard )
            _kbd_device=''${kbd_device:-"$(light -L | grep kbd_backlight)"}
            case "$2" in
                light )
                    case "$3" in
                        before )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [keyboard] [light] [timeout] 'save existing keyboard brightness'"
                            _hypridle_exec light -s ''${_kbd_device} -O
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [keyboard] [light] [timeout] 'disable keyboard light'"
                            _hypridle_exec light -s ''${_kbd_device} -S 0
                        ;;
                        after )
                            _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [keyboard] [light] [restore] 'restore keyboard brightness'"
                            _hypridle_exec light -s ''${_kbd_device} -I
                        ;;
                    esac
                ;;
            esac
        ;;
        lock )
            case "$2" in
                before )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [lock] [timeout] 'loginctl lock-session'"
                    _hypridle_exec loginctl lock-session
                ;;
                after )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [lock] [resume]"
                ;;
            esac
        ;;
        suspend )
            case "$2" in
                before )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [suspend] [timeout] 'systemctl suspend'"
                    _hypridle_exec systemctl suspend
                ;;
                after )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [suspend] [resume]"
                    #systemctl --user restart pipewire.service
                    #systemctl --user restart xdg-desktop-portal.service
                ;;
            esac
        ;;
        sleep )
            case "$2" in
                before )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [sleep] [before] 'loginctl lock-session'"
                    _hypridle_gamma set
                    _hypridle_exec loginctl lock-session
                ;;
                after )
                    _hypridle_log "$(date +'%Y-%m-%d %H:%M:%s') [after] [after] 'hyprctl dispatch dpms on'"
                    _hypridle_exec hyprctl dispatch dpms on
                    _hypridle_gamma get
                ;;
            esac
        ;;
    esac
  '';
in
  with lib;
{
  options = {
    host.home.applications.hypridle = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprland Idle Monitor";
      };
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hypridle-companion-script
        ];
    };

    services = mkIf (cfg.service.enable) {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";                                             # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "$HOME/.local/state/nix/profile/bin/hypridle-companion sleep before";                  # lock before suspend.
            after_sleep_cmd = "$HOME/.local/state/nix/profile/bin/hypridle-companion sleep after";                   # to avoid having to press a key twice to turn on the display.
          };
         listener = mkMerge [
            (mkIf (role != "laptop") (mkAfter [
              {
                timeout = 15;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion keyboard light before";             # keyboard off when timeout has passed
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion keyboard light after";               # keyboard on when activity is detected after timeout has fired.
              }
              {
                timeout = 30;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim save; $HOME/.local/state/nix/profile/bin/hypridle-companion display dim before .5";           # laptop display divided by 50%
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim after";                  # restore original laptop display
              }
              {
                timeout = 60;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim before .9 battery";     # laptop display divided by 90%
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim after";                  # restore original laptop display
              }
              {
                timeout = 180;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim before .9 battery";     # laptop display divided by 90%
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim after";                  # restore original laptop display
              }
              {
                timeout = 360;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim before .9 battery";     # laptop display divided by 90%
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim after";                  # restore original laptop display
              }
              {
                timeout = 480;
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim before .9 battery";     # laptop display divided by 90%
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display dim after";                  # restore original laptop display
              }
            ]))

            (mkAfter [
              {
                timeout = 600;                                                                                          # 10min
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion lock before";                       # lock screen when timeout has passed
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion lock after";                         # reset gamma
              }
              {
                timeout = 660;                                                                                          # 11min
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion display blank before";              # screen off when timeout has passed
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion display blank after";                # screen on when activity is detected after timeout has fired.
              }
              {
                timeout = 900;                                                                                          # 15min
                on-timeout = "$HOME/.local/state/nix/profile/bin/hypridle-companion suspend before";                    # suspend pc
                on-resume = "$HOME/.local/state/nix/profile/bin/hypridle-companion suspend after";                      # reset gamma
              }
            ])
          ];
        };
      };
    };

    systemd.user.services.hypridle = mkIf cfg.service.enable {
      Unit = mkForce {
        Description = "Idle Daemon";
        Documentation = "https://github.com/hyprwm/hypridle";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };

      Service = mkForce {
        ExecStart = "${pkgs.hypridle}/bin/hypridle";
        Restart = "always";
        RestartSec = 10;
        X-Restart-Triggers = mkIf (config.services.hypridle.settings != { })
          [ "${config.xdg.configFile."hypr/hypridle.conf".source}" ];
      };

      Install = mkForce {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
