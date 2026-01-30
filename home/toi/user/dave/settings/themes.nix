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
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
        #name = "BeautyLine";
        #package = pkgs.beauty-line-icon-theme;
      };
      theme = {
        name = "Zukitwo";
        package = pkgs.zuki-themes;
      };
    };
    #pointerCursor =  {
    #  gtk.enable = true;
    #  name = "Quintom_Snow";
    #  package = pkgs.quintom-cursor-theme;
    #};

   programs = mkIf ((role == "workstation" || role == "laptop")) {
      bash = {
        sessionVariables = {
          GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        };
      };
    };
  };
}
