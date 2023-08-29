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
          "bg+" = "#${config.colorscheme.colors.base01}";
          "fg+" = "#${config.colorscheme.colors.base06}";
          "hl+" = "#${config.colorscheme.colors.base0D}";
          bg = "#${config.colorscheme.colors.base00}";
          fg = "#${config.colorscheme.colors.base04}";
          header = "#${config.colorscheme.colors.base0D}";
          hl = "#${config.colorscheme.colors.base0D}";
          info = "#${config.colorscheme.colors.base0A}";
          marker = "#${config.colorscheme.colors.base0C}";
          pointer = "#${config.colorscheme.colors.base0C}";
          prompt = "#${config.colorscheme.colors.base0A}";
          spinner = "#${config.colorscheme.colors.base0C}";
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
