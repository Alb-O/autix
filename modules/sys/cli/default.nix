_:
let
  packages =
    pkgs: with pkgs; [
      atuin
      eza
      fd
      ffmpeg
      gh
      onefetch
      poppler-utils
      ripgrep
      rucola
      unipicker
      unison
      unzip
      yt-dlp
    ];

  hmModule =
    { pkgs, ... }:
    {
      home.packages = packages pkgs;
    };
in
{
  autix.aspects.cli = {
    description = "Common CLI tooling bundle.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
