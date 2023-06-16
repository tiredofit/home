{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs;
      [
        wget
      ];
  };
  programs = {
    bash = {
      shellAliases = {
        wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts" ; # Send history to a sane area
      };
    };
  };
}
