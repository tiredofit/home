{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wl-clipboard;
in
  with lib;
{
  options = {
    host.home.applications.wl-clipboard = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Clipboard manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wl-clipboard
        ];
    };
  };
}
