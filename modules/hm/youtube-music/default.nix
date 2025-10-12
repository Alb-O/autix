{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (with pkgs; [ youtube-music ]);
    };
in
{
  autix.aspects.youtube-music = {
    description = "Electron wrapper around YouTube Music";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
