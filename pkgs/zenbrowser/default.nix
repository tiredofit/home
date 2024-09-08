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
  rev = "1.0.0-a.37";
  linux_x86_64-hash = "1249l74sma6zzkbk2l99h7y4pk0f5bvggm0h8b76rccrcai9j7bb";
  darwin_aarch64-hash = "17ajbq43hblnasdn6n7p1gc3vzfbrmyv7483l8yca98jyq389w8c";
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
      url = "${repo_git}/releases/download/${rev}/zen.linux-generic.tar.bz2";
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
