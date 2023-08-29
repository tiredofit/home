{ pkgs, ...}:
{

  home = {
    file = {
      # ".config/whaever".source =  ../../../dotfiles/whatever;
    };

    packages = with pkgs;
      [
        ark                             # GUI archiver for thunar archive plugin
        ffmpegthumbnailer
        libgsf                          # odf files
        xfce.thunar                     # xfce4's file manager
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin
        xfce.thunar-volman
        xfce.tumbler
        xfce.xfconf
      ];
  };
}
