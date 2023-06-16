{ config, ...}:
{
  programs = {
      bat = {
      enable = true;
      config = {
        map-syntax = [ "*.jenkinsfile:Groovy" "*.props:Java Properties" ];
        pager = "less -FR";
        theme = "TwoDark";
      };
    };
  };
}
