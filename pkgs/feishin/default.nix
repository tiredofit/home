{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "feishin";
  version = "v1.6.0";

  extraPkgs = pkgs: [
    pkgs.gnome-keyring
    pkgs.libsecret
  ];

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "0pf3i613znxd5n7sqwbf2nbyzjzjbnvyf7g0rz125l555zsj00rc";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "feishin";
      exec = "feishin";
      terminal = false;
      desktopName = "Feishin";
      comment = "Media Player";
      categories = [ "Network" ];
    })
  ];
}
