_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ youtube-music ];
    };
in
{
  flake.aspects.youtube-music = {
    description = "Electron wrapper around YouTube Music";
    homeManager = hmModule;
  };
}
