{config, lib, pkgs, ...}:

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
    fonts = {
      fontconfig = {
        enable = true ;
      };
    };

    home.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      #material-design-icons
      nerd-fonts.hack
      nerd-fonts.noto
      nerd-fonts.ubuntu
      noto-fonts
      noto-fonts-color-emoji
      open-sans
      roboto
      ubuntu_font_family
    ];

    fonts = {
      fontconfig = {
        defaultFonts = {
          serif = [
            "Noto Serif NF"
            "Noto Serif"
            "Liberation Serif"
            "DejaVu Serif"
          ];
          sansSerif = [
            "Noto Sans NF"
            "Noto Sans"
            "Roboto"
            "Open Sans"
            "Liberation Sans"
            "DejaVu Sans"
          ];
          monospace = [
            "Hack Nerd Font"
            "NotoSansM Nerd Font Mono"
            "Noto Sans Mono"
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
