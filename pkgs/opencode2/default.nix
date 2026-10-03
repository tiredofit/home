{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  ripgrep,
}:

let
  version = "2.0.22";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-linux-x64/-/cli-linux-x64-${version}.tgz";
      hash = "sha256-ZUNMviVvI985eklBA55e7iixo3wbrVN2pSF/WDo1NYM=";
    };
    aarch64-linux = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-linux-arm64/-/cli-linux-arm64-${version}.tgz";
      hash = "sha256-SeVGbeYPZQAc3ddYNBn4QhQGl9rq0rTYgmvlTZBW5ws=";
    };
    aarch64-darwin = fetchurl {
      url = "https://registry.npmjs.org/@opencode/cli-darwin-arm64/-/cli-darwin-arm64-${version}.tgz";
      hash = "sha256-FvX1hR4Pz4bcOMmAQrxQ5fFnMZqZc4l8lIfxey6BARc=";
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
