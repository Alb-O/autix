{ stdenv, fetchurl }:
stdenv.mkDerivation {
  pname = "models-dev";
  version = "latest";

  src = fetchurl {
    url = "https://models.dev/api.json";
    sha256 = "sha256-6nDrv/wquEuwhWgERlak7aalQwZ3u26ZlHTiAbU/GXw=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/dist
    cp $src $out/dist/_api.json
  '';
}
