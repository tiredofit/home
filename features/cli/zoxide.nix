{ config, ...}:
{
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
