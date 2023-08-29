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
      caladea
      cantarell-fonts
      carlito
      courier-prime
      dejavu_fonts
      font-awesome
      gelasio
      liberation_ttf
      material-design-icons
      merriweather
      noto-fonts
      noto-fonts-emoji
      open-sans
      roboto
      ubuntu_font_family
      weather-icons
      # nerdfonts
      (nerdfonts.override { fonts = [
        "DroidSansMono"
        "Hack"
        "JetBrainsMono"
        "Noto"
      ];})
    ];
  };
}
