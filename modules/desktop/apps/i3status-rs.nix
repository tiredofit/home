{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.i3status-rust;
in
  with lib;
{
  options = {
    host.home.applications.i3status-rust = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway/i3 status bar";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          i3status-rust
        ];
    };
  };
}
