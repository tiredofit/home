{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) role username;
  cfg = config.host.home.feature.theming;
  stylixOff = !cfg.stylix.enable;

  tokyonight-gtk = pkgs.stdenvNoCC.mkDerivation {
    pname = "tokyonight-gtk-theme";
    version = "unstable-2025";

    src = pkgs.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyonight-GTK-Theme";
      rev = "master";
      hash = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cp -r themes/* $out/share/themes/
      runHook postInstall
    '';
  };
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
          name = "Tokyonight-Dark";
          package = tokyonight-gtk;
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

    programs = mkIf (role == "workstation" || role == "laptop") (let
        sessionVars = mkIf stylixOff {
          GTK2_RC_FILES = mkForce "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
          GTK_THEME = "Tokyonight-Dark";
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