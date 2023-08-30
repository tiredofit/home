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

  config = mkIf cfg.enable {
    programs = {
      lsd = {
        enable = true;
        settings = {
          blocks = [ "permission" "user" "group" "size" "date" "name" ];
          date = "date";
          ignore-globs = [ ".git" ".hg" ];
        };
      };

      bash.shellAliases = {
        ls = "lsd --hyperlink=auto" ; # directory list alternative
      };
    };
  };
}
