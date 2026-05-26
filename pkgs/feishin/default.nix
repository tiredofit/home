{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  symlinkJoin,
}:

let
  pname = "feishin";
  version = "v1.12.0";

  src = fetchurl {
    url = "https://github.com/jeffvli/feishin/releases/download/${version}/Feishin-linux-x86_64.AppImage";
    sha256 = "1l9jn4a7q5vlk43f92n3xmmr07dxd9ld6q1ywhzck249zzzfw5ws";
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
