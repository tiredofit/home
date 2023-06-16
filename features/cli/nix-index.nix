{ config, ...}:
{
  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
