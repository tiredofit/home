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
    sha256 = "10ccch2r2jjcf62759b9pdfqf8mww9cfp199pbqs668qpv457lx0";
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
