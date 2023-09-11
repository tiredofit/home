{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.drawio;
in
  with lib;
{
  options = {
    host.home.applications.drawio = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Diagram tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          drawio
        ];
    };

    xdg.configFile."draw-io/config.json".text = ''
{
	"dontCheckUpdates": true,
}
    '';

    xdg.configFile."draw-io/Preferences".text = ''
{
    "brightray": {
        "media": {
            "device_id_salt": "U3AJsbjfUzm8pTW61UoxGQ=="
        }
    },
    "selectfile": {
        "last_directory": "~/"
    },
    "spellcheck": {
        "dictionaries": [
            "en-US"
        ],
        "dictionary": ""
    }
}
    '';
  };
}
