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
  rev = "1.12.5b";
  linux_x86_64-hash = "0xx5760jxzkiqvk05ghw1rrdrgh4n0z6gk0xw8gsjsvbjvsd9h7c";
  darwin_universal-hash = "0q791a734cc80ic01ds05l20q5y5ja0r29ijwnfm5k0i0sa1zhag";
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
