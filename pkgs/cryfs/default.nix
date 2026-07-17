{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  boost,
  curl,
  fuse2,
  gtest,
  openssl,
  range-v3,
  spdlog,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "cryfs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "cryfs";
    repo = "cryfs";
    rev = version;
    hash = "sha256-bBe//AjA9QmdSDlb0xiOboE5F4g6LJ03cHQZpfOk+Y4=";
  };

  postPatch = ''
    patchShebangs src

    substituteInPlace test/cpp-utils/CMakeLists.txt \
      --replace "network/CurlHttpClientTest.cpp" "" \
      --replace "network/FakeHttpClientTest.cpp" ""

    substituteInPlace test/cryfs-cli/CMakeLists.txt \
      --replace "CliTest_IntegrityCheck.cpp" "" \
      --replace "CliTest_Setup.cpp" "" \
      --replace "CliTest_WrongEnvironment.cpp" "" \
      --replace "CryfsUnmountTest.cpp" ""

    substituteInPlace test/cpp-utils/data/DataTest.cpp \
      --replace "(4.5L*1024*1024*1024)" "(0.5L*1024*1024*1024)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  strictDeps = true;

  buildInputs = [
    boost
    curl
    fuse2
    gtest
    openssl
    range-v3
    spdlog
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    "-DDEPENDENCY_CONFIG='../cmake-utils/DependenciesFromLocalSystem.cmake'"
    "-DCRYFS_UPDATE_CHECKS:BOOL=FALSE"
    "-DBoost_USE_STATIC_LIBS:BOOL=FALSE"
    "-DBUILD_TESTING:BOOL=${if doCheck then "TRUE" else "FALSE"}"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)

    SKIP_IMPURE_TESTS="CMakeFiles|fspp|my-gtest-main"

    for t in $(ls -d test/*/ | grep -E -v "$SKIP_IMPURE_TESTS") ; do
      "./$t$(basename $t)-test"
    done

    runHook postCheck
  '';

  meta = {
    description = "Cryptographic filesystem for the cloud";
    homepage = "https://www.cryfs.org/";
    changelog = "https://github.com/cryfs/cryfs/raw/${version}/ChangeLog.txt";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      sigmasquadron
    ];
    platforms = lib.platforms.unix;
  };
}
