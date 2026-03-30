{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lsd;
in
  with lib;
{
  options = {
    host.home.applications.lsd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Directory List Alternative";
      };
    };
  };

  config = mkIf cfg.enable (let
    aliases = {
      ls = "lsd --hyperlink=auto";
    };

    sessionVars = {};
  in {
    home = {
      packages = with pkgs; [
        lsd
      ];
    };

    programs = {
      lsd = {
        enable = true;
        enableBashIntegration = mkDefault true;
        enableZshIntegration = mkDefault true;
        settings = {
          blocks = [ "permission" "user" "group" "size" "date" "name" ];
          date = "date";
          ignore-globs = [ ".git" ".hg" ];
        };

      };

      bash = {
        shellAliases = mkForce aliases;
      };
      zsh = {
        shellAliases = lib.mkForce aliases;
      };
    };
  });
}
