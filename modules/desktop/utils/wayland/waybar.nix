{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.waybar;

  script_displayhelper_waybar = pkgs.writeShellScriptBin "displayhelper_waybar" ''
    _get_display_name() {
        ${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg desc "$(echo "''${1}" | sed "s|^d/||g")" '.[] | select(.description | test("^(d/)?\($desc)")) | .name'
    }

    if [ -z "''${1}" ]; then exit 1; fi

    _tmp_waybar_config=$(mktemp)
    case "''${1}" in
        * )
            display_name=$(_get_display_name "''${1}")
            jq -n \
                --arg output "''${display_name}" \
                --arg xdg_config_home "''${XDG_CONFIG_HOME}" \
                    '
                      [
                          {
                              "output": $output,
                              "include": ($xdg_config_home + "/waybar/bar-primary.json")
                          }
                      ]
                    ' \
                    > ''${_tmp_waybar_config}
            shift
        ;;
    esac

    for display in "''${@}" ; do
        display_counter=''${display_counter:-"2"}

        case "''${display_counter}" in
            2 )
                _bar_name="secondary"
            ;;
            3 )
                _bar_name="tertiary"
            ;;
            * )
                _bar_name="wildcard"
            ;;
        esac

        display_name=$(_get_display_name "''${display}")

        if [ "''${display_counter}" -le 3 ] ; then
            if [ -z "''${display_name}" ] ; then break; fi
            jq \
                --arg bar_name "''${_bar_name}" \
                --arg output "''${display_name}" \
                --arg xdg_config_home "''${XDG_CONFIG_HOME}" \
                    ' . +
                        [
                            {
                                "output": $output,
                                "include": ($xdg_config_home + "/waybar/bar-" + $bar_name + ".json")
                            }
                        ]
                    ' \
                        ''${_tmp_waybar_config} > ''${_tmp_waybar_config}-temp && mv ''${_tmp_waybar_config}-temp ''${_tmp_waybar_config}

            (( display_counter+=1 ))
        else
            jq \
                '. +
                    [
                        {
                            "output": (map("!" + .output) | join(", ")),
                            "include": ($xdg_config_home + "/waybar/bar-wildcard.json"
                        }
                    ]
                ' \
                        ''${_tmp_waybar_config} > ''${_tmp_waybar_config}-temp && mv ''${_tmp_waybar_config}-temp ''${_tmp_waybar_config}
        fi
    done

    cp -aR "''${_tmp_waybar_config}" "''${XDG_CONFIG_HOME}"/waybar/config
    rm -rf \
        "''${_tmp_waybar_config}" \
        "''${_tmp_waybar_config}"-temp
    systemctl --user restart waybar.service
  '';
in
  with lib;
{
  options = {
    host.home.applications.waybar = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Status bar for Wayland";
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
          script_displayhelper_waybar
        ];
    };

    programs = {
      waybar = {
        enable = true;
        package = pkgs.unstable.waybar;
        systemd.enable = false;
      };
    };

    systemd.user.services.waybar = mkIf cfg.service.enable {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "man:waybar(5)";
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}