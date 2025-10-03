{ lib, ... }:
let
  packages =
    pkgs: with pkgs; [
      atuin
      eza
      fd
      ffmpeg
      gh
      onefetch
      poppler_utils
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
      home.packages = lib.mkAfter (packages pkgs);
    };

  moduleArgs = {
    autixPackages = {
      tooling = {
        cli = packages;
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.cli-bundle = pkgs.symlinkJoin {
        name = "autix-bundle-cli";
        paths = packages pkgs;
      };
    };
in
{
  autix.home.modules.cli = hmModule;

  inherit perSystem;

  _module.args = moduleArgs;
}
