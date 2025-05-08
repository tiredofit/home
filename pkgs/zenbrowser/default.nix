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
  rev = "1.12.2b";
  linux_x86_64-hash = "1vm2ag6mbcvp4iq9c4lac409vc1vq4177vvlgh49mbsgxvpydm9p";
  darwin_universal-hash = "1x2y67qflg9rxnbgscirmwnm7i9vh0rpka5aayyf71kgy0damr1h";
  domain = "github.com";
  owner = "zen-browser";
  repo = "desktop";
  repo_git = "https://${domain}/${owner}/${repo}";
  sources = {
    aarch64-darwin = fetchurl {
      url = "${repo_git}/releases/download/${rev}/zen.macos-universal.dmg";
      sha256 = darwin_universal-hash;
    };
    x86_64-linux = fetchurl {
      url = "${repo_git}/releases/download/${rev}/zen.linux-x86_64.tar.xz";
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
      tar xJvf ${finalAttrs.src} -C $out
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
