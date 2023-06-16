{ config, ...}:
{
  programs = {
    zathura = {
      enable = true;
      options = {
        default-bg = "#000000";
        default-fg = "#FFFFFF";
      };
    };
  };
}
