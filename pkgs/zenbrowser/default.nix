{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  undmg,
  makeWrapper,
  autoPatchelfHook,
  pango,
  gtk3,
  glibc,
  alsa-lib,
}:

let
  rev = "1.7.1b";
  linux_x86_64-hash = "1b2hhbnqbkvs5n6hbhwgwqzj56lszrgas3q79vlysymkfmw1zbnq";
  darwin_aarch64-hash = "1309w0i2lab39c30syfsq5d8mrnvhl9nsgkp6h4jraxwc59a0azy";
  domain = "github.com";
  owner = "zen-browser";
  repo = "desktop";
  repo_git = "https://${domain}/${owner}/${repo}";
  sources = {
    aarch64-darwin = fetchurl {
      url = "${repo_git}/releases/download/${rev}/zen.macos-aarch64.dmg";
      sha256 = darwin_aarch64-hash;
    };
    x86_64-linux = fetchurl {
      url = "${repo_git}/releases/download/${rev}/zen.linux-x86_64.tar.bz2";
      sha256 = linux_x86_64-hash;
    };
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "zen-browser";
    version = "${rev}";

    src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

    dontUnpack = stdenv.isDarwin;
    unpackPhase = ''
      mkdir -p $out
      tar xjvf ${finalAttrs.src} -C $out
    '';

    nativeBuildInputs = lib.optionals stdenv.isLinux [
      alsa-lib
      autoPatchelfHook
      glibc
      gtk3
      pango
      stdenv.cc.cc.lib
    ];
    buildInputs = [
      makeWrapper
    ] ++ lib.optionals stdenv.isDarwin [
      undmg
    ];

    buildPhase = if stdenv.isDarwin then ''
      undmg ${finalAttrs.src}
      mkdir -p $out/bin
      cp -r "Zen Browser.app" $out
      makeWrapper "$out/Zen Browser.app/Contents/MacOS/zen" "$out/bin/zenbrowser"
    '' else ''
      mkdir -p $out/bin
      makeWrapper "$out/zen/zen-bin" "$out/bin/zenbrowser"
    '';
  })
