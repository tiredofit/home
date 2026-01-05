{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "feishin";
  version = "v1.2.0";

  extraPkgs = pkgs: [
    pkgs.gnome-keyring
    pkgs.libsecret
  ];

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "13lrpphr7aqz587rnbqkwc4nkxg4bvv8xhcwpwr3k8avshwz25y4";
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
