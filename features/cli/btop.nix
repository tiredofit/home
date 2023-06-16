{ config, ...}:
{
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
      };
    };

    bash.shellAliases = {
      top = "btop" ; # Process viewer
    };
  };
}
