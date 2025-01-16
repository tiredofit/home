{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.shikane;
  tomlFormat = pkgs.formats.toml { };
in
  with lib;
{
  options = {
    host.home.applications.shikane = {
      enable = mkOption {
        default = true;
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
