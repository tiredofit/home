{config, inputs, lib, pkgs, specialArgs, ...}:
let
  inherit (specialArgs) role username;
  cfg = config.host.home.feature.theming;
  stylixOff = !cfg.stylix.enable;
in
  with lib;
{
  config = mkIf config.host.home.feature.theming.enable {
    # GTK config — manual theme when stylix is off, icon overlay when on.
    gtk = mkIf (role == "workstation" || role == "laptop") (mkMerge [
      # Manual theme (no stylix): full catppuccin + bibata cursor + papirus
      (mkIf stylixOff {
        enable = mkDefault true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = mkDefault 1;
        gtk4 = {
          extraConfig.gtk-application-prefer-dark-theme = mkDefault 1;
          theme = mkDefault config.gtk.theme;
        };
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = mkDefault 24;
        };
        theme = {
          name = "Catppuccin-Mocha";
          package = pkgs.catppuccin-gtk.override {
            tweaks = [ "rimless" ];
            variant = "mocha";
          };
        };
      })
      # Stylix mode: just add Papirus icons on top (stylix owns everything else)
      (mkIf (!stylixOff) {
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      })
    ]);

    programs = mkIf ((role == "workstation" || role == "laptop")) (let
        sessionVars = mkIf stylixOff {
          GTK2_RC_FILES = mkForce "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
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
