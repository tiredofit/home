{ pkgs, ...}:
{

  home = {
    packages = with pkgs;
      [
        gnome.gnome-system-monitor
      ];
  };
}
