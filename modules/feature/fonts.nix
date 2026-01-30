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
      #roboto
      #ubuntu-classic
      corefonts
      dejavu_fonts
      font-awesome
      liberation_ttf
      nerd-fonts.hack
      nerd-fonts.noto
      nerd-fonts.symbols-only
      nerd-fonts.ubuntu
      noto-fonts
      #noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      #noto-fonts-emoji-blob-bin
      open-sans
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
        configFile = {
          embedded-bitmaps = {
            enable = true;
            priority = 50;
            text = ''
              <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
              <fontconfig>
                <match target="font">
                  <edit name="embeddedbitmap" mode="assign">
                    <bool>true</bool>
                  </edit>
                </match>
              </fontconfig>
            '';
          };
        };
      };
    };
  };
}
