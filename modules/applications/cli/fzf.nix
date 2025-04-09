{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.fzf;
in
  with lib;
{
  options = {
    host.home.applications.fzf = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Fuzzy Finder";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      fzf = {
        enable = true;
        enableBashIntegration = true;
        colors = {
          "bg+" = "#${config.colorScheme.palette.base01}";
          "fg+" = "#${config.colorScheme.palette.base06}";
          "hl+" = "#${config.colorScheme.palette.base0D}";
          bg = "#${config.colorScheme.palette.base00}";
          fg = "#${config.colorScheme.palette.base04}";
          header = "#${config.colorScheme.palette.base0D}";
          hl = "#${config.colorScheme.palette.base0D}";
          info = "#${config.colorScheme.palette.base0A}";
          marker = "#${config.colorScheme.palette.base0C}";
          pointer = "#${config.colorScheme.palette.base0C}";
          prompt = "#${config.colorScheme.palette.base0A}";
          spinner = "#${config.colorScheme.palette.base0C}";
        };
        defaultOptions = [
          "--height 40%"
          "--border"
        ];
        fileWidgetOptions = [
          "--preview 'head {}'"
        ];
        historyWidgetOptions = [
          "--sort"
        ];
      };
    };
  };
}
