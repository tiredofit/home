{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:


appimageTools.wrapType2 rec {
  pname = "mqtt-explorer";
  version = "0.4.0-beta.6";

  src = fetchurl {
    url = "https://github.com/thomasnordquist/MQTT-Explorer/releases/download/v0.4.0-beta.6/MQTT-Explorer-0.4.0-beta.6.AppImage";
    hash = "sha256-zEosMda2vtq+U+Lrvl6DExvT5cGPbDz0eJo7GRlVzVA=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "mqtt-explorer";
      exec = "mqtt-explorer";
      terminal = false;
      desktopName = "MQTT Explorer";
      comment = "Message Queue Explorer";
      categories = [ "Network" ];
    })
  ];
}
