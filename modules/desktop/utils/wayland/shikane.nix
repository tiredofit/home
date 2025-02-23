{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.shikane;

  tomlFormat = pkgs.formats.toml { };

  shikane_display_helper_tool = pkgs.writeShellScriptBin "displayhelper_shikane" ''
    if command -v "rofi" &>/dev/null ; then
        choose_menu="rofi"
        choose_menu_command="rofi -dmenu -i"
    elif command -v "dmenu" &>/dev/null ; then
        choose_menu="dmenu"
        choose_menu_command='dmenu'
    else
        choose_menu="select"
    fi

    if [ "$choose_menu" = "select" ] ; then
        PS3="Choose an display profile "
        IFS=$'\n'
        select profile in $(awk -F'"' '/name =/ {print $2}' ~/.config/shikane/config.toml) ; do
            profile=profile
            break
        done
    else
        profile="$(awk -F'"' '/name =/ {print $2}' ~/.config/shikane/config.toml | $choose_menu_command -p 'Select a display profile')"
    fi

    ${pkgs.shikane}/bin/shikanectl switch "$profile"
  '';
in
  with lib;
{
  options = {
    host.home.applications.shikane = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Dynamic output configuration tool";
      };
      settings = mkOption {
        type = tomlFormat.type;
        default = { };
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
          shikane
          shikane_display_helper_tool
        ];
    };

    systemd.user.services.shikane = mkIf cfg.service.enable {
      Unit = {
        Description = "Dynamic output configuration tool";
        Documentation = "man:shikane(1)";
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.shikane}/bin/shikane -c" + config.xdg.configFile."shikane/config.toml".target;
        ExecReload = "${pkgs.shikane}/bin/shikanectl reload";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg = {
      configFile = {
        "shikane/config.toml" = {
          source = "${tomlFormat.generate "skikane" cfg.settings}";
        };
      };
    };
  };
}
