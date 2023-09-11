{config, inputs, lib, pkgs, ...}:

let
  cfg = config.host.home.feature.theming;
in
  with lib;
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  options = {
    host.home.feature.theming = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable theming";
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = inputs.nix-colors.colorSchemes.dracula;
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Zukitwo";
        package = pkgs.zuki-themes;
      };
    };

    home = {
      packages = with pkgs;
        [
          lxappearance
        ];

      pointerCursor = {
        gtk.enable = true;
        name = "Quintom_Snow";
        package = pkgs.quintom-cursor-theme;
      };
    };

    programs = {
      bash = {
        sessionVariables = {
          GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        };
      };
    };
  };
}
