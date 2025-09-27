{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (
        with pkgs;
        [
          gh
          unzip
          ffmpeg
          yt-dlp
          atuin
          unison
          rucola
          onefetch
          poppler_utils
          unipicker
          ripgrep
          fd
          eza
        ]
      );
    };

  autix = {
    home.modules."tooling-cli" = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
