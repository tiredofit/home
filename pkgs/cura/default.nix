{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "cura";
  version = "5.7.1";

  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-LZMD0fo8TSlDEJspvTka724lYq5EgrOlDkwMktXqATw=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "cura";
      exec = "cura";
      terminal = false;
      desktopName = "Ultimaker Cura";
      comment = meta.description;
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    description = "Ultimaker Cura Printing Slicing Software";
    homepage = "https://ultimaker.com/es/software/ultimaker-cura/";
    changelog = "https://github.com/Ultimaker/Cura/releases/tag/${finalAttrs.version}";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    mainProgram = "cura";
  };
}