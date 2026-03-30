{config, inputs, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role username;
  cfg = config.host.home.feature.theming;
in
  with lib;
{
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  config = mkIf config.host.home.feature.theming.enable {
    #colorScheme = inputs.nix-colors.colorSchemes.dracula;

  gtk = mkIf ((role == "workstation" || role == "laptop")) {
    enable = mkDefault true;
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = mkDefault 1;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = mkDefault 1;
      };
      theme = mkDefault config.gtk.theme;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    #pointerCursor =  {
    #  gtk.enable = true;
    #  name = "Quintom_Snow";
    #  package = pkgs.quintom-cursor-theme;
    #};

    theme = {
      name = "Catppuccin-Mocha";
      package = pkgs.catppuccin-gtk.override {
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
  };

   programs = mkIf ((role == "workstation" || role == "laptop")) (let
      sessionVars = {
        GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        GTK_THEME = "Catppuccin-Mocha";
      };
    in {
      bash = {
        sessionVariables = sessionVars;
      };
      zsh = {
        sessionVariables = sessionVars;
      };
    });
  };
}
