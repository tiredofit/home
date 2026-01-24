{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "feishin";
  version = "v1.3.0";

  extraPkgs = pkgs: [
    pkgs.gnome-keyring
    pkgs.libsecret
  ];

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "19g971c6m5xslngjrn3hvbl6rq4jr9yapxqp53qsk2gg0ifa19nr";
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
