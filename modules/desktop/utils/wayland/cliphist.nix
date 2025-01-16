{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cliphist;
in
  with lib;
{
  options = {
    host.home.applications.cliphist = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland clipboard history";
      };
      max_items = mkOption {
        default = "500";
        type = with types; str;
        description = "Maximum number of items to Store";
      };
      max_dedupe_search = mkOption {
        default = "10";
        type = with types; str;
        description = " Maximum number of last items to look through when finding duplicates";
      };
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
      store_images = mkOption {
        default = false;
        type = with types; bool;
        description = "Save images as well as text";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cliphist
        ];
    };

    systemd = {
      user = {
        services = {
          cliphist = mkIf cfg.service.enable {
            Unit = {
              Description = "Clipboard management daemon";
              Documentation = "https://github.com/sentriz/cliphist";
              After = [ "graphical-session.target" ];
            };

            Service = {
              Type = "exec";
              ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist -max-items " + cfg.max_items + " -max-dedupe-search " + cfg.max_dedupe_search + " store";
              ExecReload = "kill -SIGUSR2 $MAINPID";
              Restart = "on-failure";
              Slice = "app-graphical.slice";
            };

            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };

          cliphist-images = mkIf (cfg.service.enable && cfg.store_images) {
            Unit = {
              Description = "Clipboard management daemon";
              Documentation = "https://github.com/sentriz/cliphist";
              After = [ "graphical-session.target" ];
            };

            Service = {
              Type = "exec";
              ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist -max-items " + cfg.max_items + " -max-dedupe-search " + cfg.max_dedupe_search + " store";
              ExecReload = "kill -SIGUSR2 $MAINPID";
              Restart = "on-failure";
              Slice = "app-graphical.slice";
            };

            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };
        };
      };
    };
  };
}

