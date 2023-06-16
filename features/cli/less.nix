{ config, ...}:
{
  programs = {
    less = {
       enable = true;
       keys = ''
         s back-line
         t forw-line
       '';
     };
    bash = {
      sessionVariables = {
        LESSHISTFILE="$XDG_CACHE_HOME/less/history";
      };
      shellAliases = {
        "more" = "less"; # pager
      };
    };
  };
}
