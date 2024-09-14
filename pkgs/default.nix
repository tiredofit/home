pkgs: {
  pkg-cura = pkgs.callPackage ./cura { } ;
  pkg-wayprompt = pkgs.callPackage ./wayprompt { } ;
  pkg-zenbrowser = pkgs.callPackage ./zenbrowser { } ;
}
