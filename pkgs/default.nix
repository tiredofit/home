pkgs: {
  pkg-cura = pkgs.callPackage ./cura { } ;
  pkg-mqtt-explorer = pkgs.callPackage ./mqtt-explorer { } ;
  pkg-wayprompt = pkgs.callPackage ./wayprompt { } ;
  pkg-zenbrowser = pkgs.callPackage ./zenbrowser { } ;
}
