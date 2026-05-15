{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  symlinkJoin,
}:

let
  pname = "feishin";
  version = "v1.11.0";

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "12havkv29d983c5wsx9px9jdgs4rn6a95gqls3amf55sgn48afw4";
  };

  extracted = appimageTools.extract { inherit pname version src; };

  wrapped = appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [
      pkgs.gnome-keyring
      pkgs.libsecret
    ];
  };

  desktop = makeDesktopItem {
    name = "feishin";
    exec = "feishin";
    terminal = false;
    desktopName = "Feishin";
    comment = "Media Player";
    categories = [ "AudioVideo" "Audio" ];
    icon = "feishin";
  };

in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [ wrapped desktop extracted ];
  postBuild = ''
    icon_src="${extracted}/usr/share/icons/hicolor/512x512/apps/feishin.png"
    if [ -f "$icon_src" ]; then
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp "$icon_src" $out/share/icons/hicolor/512x512/apps/feishin.png
    fi
  '';
}
