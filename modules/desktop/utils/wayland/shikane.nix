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
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          shikane
        ];
    };

    systemd.user.services.shikane = {
      Unit = {
        Description = "Dynamic output configuration tool";
        Documentation = "man:shikane(1)";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.shikane}/bin/shikane -c ${tomlFormat.generate "shikane-config" cfg.settings}";
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec = [
          "systemctl --user restart shikane.service"
        ];
      };
    };
  };
}
