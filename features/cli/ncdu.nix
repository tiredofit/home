{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs;
      [
        ncdu
      ];
  };

  xdg.configFile."ncdu/config".text = ''
    -e
    --exclude .git
    --exclude .snapshots
    --exclude-kernfs
    --exclude /var/lib/docker
  '';
}
