pkgs: {
  pkg-bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor { };
  pkg-cura = pkgs.callPackage ./cura { } ;
  pkg-feishin = pkgs.callPackage ./feishin { } ;
  pkg-mqtt-explorer = pkgs.callPackage ./mqtt-explorer { } ;
  pkg-zenbrowser = pkgs.callPackage ./zenbrowser { } ;
}
