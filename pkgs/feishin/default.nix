{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  symlinkJoin,
}:

let
  pname = "feishin";
  version = "v1.15.0";

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "0r9qf6f026bg22y1bvb73a8yir4j4x5ki832m2bgdjl915lh31l7";
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
