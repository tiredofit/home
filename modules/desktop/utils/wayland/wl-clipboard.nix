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

    programs = (let
      shellFunctions = ''
        copyfile() {
          # copy file contents to clipboard
          # syntax: copyfile <file>
          if [ -z "$1" ]; then echo "Usage: copyfile <file>"; return 1; fi
          if command -v wl-copy >/dev/null 2>&1; then
            cat "$1" | wl-copy
          else
            echo "no clipboard utility available"
            return 1
          fi
        }

        copypath() {
          # copy a path string to clipboard
          # syntax: copypath <path>
          if [ -z "$1" ]; then echo "Usage: copypath <path>"; return 1; fi
          if command -v wl-copy >/dev/null 2>&1; then
            printf "%s" "$1" | wl-copy
          else
            echo "no clipboard utility available"
            return 1
          fi
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
