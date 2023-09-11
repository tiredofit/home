{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.android-tools;
in
  with lib;
{
  options = {
    host.home.applications.android-tools = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Tools to access android devices (adb, fastboot)";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            android-tools
            libmtp
          ];
    };

    programs = {
      bash = {
        sessionVariables = {
          ANDROID_HOME = "$XDG_DATA_HOME/android"; # Keep $HOME clean
        };
      };
    };
  };
}
