{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.networkmanager;
in
  with lib;
{
  options = {
    host.home.applications.networkmanager = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Network Manager GUI";
      };
      systemtray.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable starting applet in system tray";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf cfg.systemtray.enable (with pkgs; [
       networkmanagerapplet
     ]);

    wayland.windowManager.hyprland = mkIf ((cfg.systemtray.enable) && (config.host.home.feature.gui.isHyprland)) {
      settings = {
        on = [{ _args = ["hyprland.start" (lib.generators.mkLuaInline "function() hl.exec_cmd('${config.host.home.feature.uwsm.prefix}nm-applet') end")]; }];
        window_rule = [
          {
            float = true;
            match = {
              class = "^(nm-applet|nm-connection-editor)$";
            };
          }
        ];
      };
    };

    programs = (let
      shellFunctions = ''
        wifi_scan() {
          # scan and list Wi‑Fi networks using nmcli
          # syntax: wifi_scan
          nmcli device wifi rescan && nmcli device wifi list
        }
      '';
    in {
      bash = mkIf config.host.home.applications.bash.enable {
        initExtra = shellFunctions;
      };

      zsh = mkIf config.host.home.applications.zsh.enable {
        initContent = shellFunctions;
      };
    });
  };
}
