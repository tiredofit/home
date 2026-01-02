{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "feishin";
  version = "v1.1.0";

  extraPkgs = pkgs: [
    pkgs.gnome-keyring
    pkgs.libsecret
  ];

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "1dh047w9134giq9q28vkq7i247n2zg9yaaqldl93sw83y70p05xi";
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
