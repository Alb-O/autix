{ lib, pkgs, ... }:
{
  flake.modules.homeManager."tooling-cli" = {
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
}
