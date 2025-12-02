{config, lib, pkgs, ...}:
## PERSONALIZE
let
  cfg = config.host.home.feature.fonts;
in
  with lib;
{
  options = {
    host.home.feature.fonts = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable fonts";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      nerd-fonts.hack
      nerd-fonts.noto
      nerd-fonts.ubuntu
      #noto-fonts
      noto-fonts-color-emoji
      open-sans
      roboto
      ubuntu-classic
    ];

    fonts = {
      fontconfig = {
        enable = mkDefault true;
        defaultFonts = {
          serif = [
            "Noto Serif NF"
            "Liberation Serif"
            "DejaVu Serif"
          ];
          sansSerif = [
            "Noto Sans NF"
            "Roboto"
            "Open Sans"
            "Liberation Sans"
            "DejaVu Sans"
          ];
          monospace = [
            "Hack Nerd Font"
            "NotoSansM Nerd Font Mono"
            "DejaVu Sans Mono"
            "Liberation Mono"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
