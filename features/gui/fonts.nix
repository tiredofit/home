{ config, pkgs, ... }:

{
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
}
