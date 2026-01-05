{ config, inputs, lib, pkgs, specialArgs, ... }:
## PERSONALIZE
let
  cfg = config.host.home.applications.hyprpaper;
   script_displayhelper_hyprlock = pkgs.writeShellScriptBin "displayhelper_hyprpaper" ''
    _get_display_name() {
        ${pkgs.wlr-randr}/bin/wlr-randr --json | ${pkgs.jq}/bin/jq -r --arg desc "$(echo "''${1}" | sed "s|^d/||g")" '.[] | select(.description | test("^(d/)?\($desc)")) | .name'
    }

    _restart_hyprpaper() {
        systemctl --user restart hyprpaper.service
    }

    if [ -z "''${1}" ]; then
        exit 1
    else
        _monitor1=$(_get_display_name "''${1}")
        echo "splash=false" > ''${HOME}/.config/hypr/hyprpaper.conf
        cat >> ''${HOME}/.config/hypr/hyprpaper.conf <<EOF

wallpaper {
  monitor = $_monitor1
  path = ~/.config/hypr/background/middle.jpg
}
EOF
        if [ -n "''${2}" ]; then
            _monitor2=$(_get_display_name "''${2}")
            cat >> ''${HOME}/.config/hypr/hyprpaper.conf <<EOF

wallpaper {
  monitor = $_monitor2
  path = ~/.config/hypr/background/right.jpg
}
EOF
        fi

        if [ -n "''${3}" ]; then
          _monitor3=$(_get_display_name "''${3}")
          cat >> ''${HOME}/.config/hypr/hyprpaper.conf <<EOF

wallpaper {
  monitor = $_monitor3
  path = ~/.config/hypr/background/left.jpg
}
EOF
        fi

        _restart_hyprpaper
    fi
  '';
in
  with lib;
{
  options = {
    host.home.applications.hyprpaper = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Wallpaper Manager";
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
      file = {
        ".config/hypr/background".source = ../../../../dotfiles/hypr/background;
      };
      packages = with pkgs;
        [
          hyprpaper
          script_displayhelper_hyprlock
        ];
    };

    systemd.user.services.hyprpaper = mkIf cfg.service.enable {
      Unit = mkForce {
        Description = "Wallpaper Daemon";
        Documentation = "https://github.com/hyprwm/hyprpaper";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
        X-Restart-Triggers= [ "~/.config/hypr/hyprpaper.conf" ];
      };

      Service = mkForce {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "always";
        RestartSec = 10;
      };

      Install = mkForce {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
