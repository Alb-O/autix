_:
let
  version = "0.206.6";

  # Custom package that downloads pre-built binary from GitHub releases
  zedBinaryPackage =
    { lib
    , stdenv
    , fetchurl
    , autoPatchelfHook
    , makeWrapper
    , alsa-lib
    , fontconfig
    , libxkbcommon
    , mesa
    , openssl
    , vulkan-loader
    , wayland
    , libGL
    , xorg
    , zlib
    ,
    }:
    stdenv.mkDerivation {
      pname = "zed-editor";
      inherit version;

      src = fetchurl {
        url = "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz";
        sha256 = "2372e13a23a0699c394078157279632026cffe727d347ba01e961b5ee18ff0e5";
      };

      nativeBuildInputs = [
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = [
        alsa-lib
        fontconfig
        libxkbcommon
        mesa
        openssl
        vulkan-loader
        wayland
        libGL
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        zlib
      ];

      installPhase =
        let
          # Additional runtime dependencies for Wayland
          runtimeDeps = [
            wayland
            libxkbcommon
            libGL
            vulkan-loader
          ];
        in
        ''
          runHook preInstall

          mkdir -p $out/bin $out/libexec
          cp -r * $out/libexec/

          # Wrap the binary to ensure runtime libraries are available
          makeWrapper $out/libexec/bin/zed $out/bin/zed \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

          runHook postInstall
        '';

      meta = with lib; {
        description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
        homepage = "https://zed.dev";
        license = licenses.agpl3Plus;
        platforms = [ "x86_64-linux" ];
        mainProgram = "zed";
      };
    };

  hmModule =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = pkgs.callPackage zedBinaryPackage { };
        # extensions = [
        #   "git-firefly"
        #   "charmed-icons"
        #   "tomorrow-theme"
        # ];
      };
    };
in
{
  flake.aspects.zed = {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter (binary release).";
    homeManager = hmModule;
  };
}
