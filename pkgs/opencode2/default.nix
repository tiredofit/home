{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  ripgrep,
}:

let
  version = "2.0.16";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-linux-x64/-/cli-linux-x64-${version}.tgz";
      hash = "sha256-CCIetqeBNU6b47ORirW32Rr/LyBznn4uCvgbzcCCLIo=";
    };
    aarch64-linux = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-linux-arm64/-/cli-linux-arm64-${version}.tgz";
      hash = "sha256-oTKgQZaLD86hiCTy8ZlvFJTCatbkxb5cpbm5aiu3ki4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-darwin-arm64/-/cli-darwin-arm64-${version}.tgz";
      hash = "sha256-ChRGIx+R3luA4E/9xu7Fhoyl0h+ipmB2F0ze4TyydME=";
    };
  };
in

stdenv.mkDerivation {
  pname = "opencode2";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontBuild = true;
  dontStrip = true; # stripping corrupts the payload 

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/opencode $out/bin/opencode2
    wrapProgram $out/bin/opencode2 \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    $out/bin/opencode2 --version
    runHook postInstallCheck
  '';

  meta = {
    description = "OpenCode 2 CLI";
    homepage = "https://opencode.ai";
    changelog = "https://github.com/anomalyco/opencode/commits/v2";
    downloadPage = "https://www.npmjs.com/package/@opencode/cli?activeTab=versions";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "opencode2";
    platforms = builtins.attrNames sources;
  };
}
