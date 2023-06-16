{ config, ...}:
{
  programs = {
    lsd = {
      enable = true;
      settings = {
        blocks = [ "permission" "user" "group" "size" "date" "name" ];
        date = "date";
        ignore-globs = [ ".git" ".hg" ];
      };
    };

    bash.shellAliases = {
      ls = "lsd --hyperlink=auto" ; # directory list alternative
    };
  };
}

