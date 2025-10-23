{
  lib,
  stdenv,
  stdenvNoCC,
  buildGoModule,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  models-dev,
  python3,
}:
let
  version = "0.11.2";

  # Target mapping for bun --target
  bunTarget =
    {
      "x86_64-linux" = "bun-linux-x64";
      "aarch64-linux" = "bun-linux-arm64";
      "x86_64-darwin" = "bun-darwin-x64";
      "aarch64-darwin" = "bun-darwin-arm64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    rev = "v${version}";
    # Upstream source tarball hash
    hash = "sha256-kWVDNGJS7QraLSlLh+JDvggDmskhQ0lAlKLnlmaGyQU=";
  };

  # Build TUI (Go) first
  tui = buildGoModule {
    pname = "opencode-tui";
    inherit version src;

    modRoot = "packages/tui";
    # Go modules vendor hash
    vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
    subPackages = [ "cmd/opencode" ];
    env.CGO_ENABLED = 0;
    ldflags = [
      "-s"
      "-X=main.Version=${version}"
    ];
    installPhase = ''
      runHook preInstall
      install -Dm755 "$GOPATH/bin/opencode" "$out/bin/tui"
      runHook postInstall
    '';
  };

  # Precompute node_modules via fixed-output derivation; Bun needs network
  nodeModules = stdenvNoCC.mkDerivation {
    pname = "opencode-node_modules";
    inherit version src;
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
      stdenv.cc
      python3
    ];
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --filter=opencode --force --frozen-lockfile --no-progress --ignore-scripts || bun install --filter=opencode --force --no-progress --ignore-scripts
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R node_modules "$out/"
      runHook postInstall
    '';
    dontFixup = true;
    # Node modules fixed-output hash
    outputHash = "sha256-fGf2VldMlxbr9pb3B6zVL+fW1S8bRjefJW+jliTO73A=";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation (_finalAttrs: {
  pname = "opencode";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
  ];

  patches = [ ./models-dev/opencode-local-models-dev.patch ];

  # Provide local models.dev API JSON to macro during bun build
  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";

  configurePhase = ''
    runHook preConfigure
    cp -R ${nodeModules}/node_modules .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    bun build \
      --define OPENCODE_TUI_PATH="'${tui}/bin/tui'" \
      --define OPENCODE_VERSION="'${version}'" \
      --compile \
      --target=${bunTarget} \
      --outfile=opencode \
      ./packages/opencode/src/index.ts
    runHook postBuild
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 opencode "$out/bin/opencode"
    runHook postInstall
  '';

  # Add libstdc++ to runtime path (linux)
  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram "$out/bin/opencode" \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
  '';

  meta = with lib; {
    description = "OpenCode (built from source)";
    homepage = "https://github.com/sst/opencode";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "opencode";
  };
})
