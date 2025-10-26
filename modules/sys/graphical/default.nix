_:
let
  packages =
    pkgs: with pkgs; [
      hyprpicker
      libinput
      solaar
    ];

  hmModule =
    { pkgs
    , ...
    }:
    {
      home.packages = packages pkgs;
    };
in
{
  flake.aspects.graphical = {
    description = "Graphical desktop utilities bundle.";
    homeManager = hmModule;
  };
}
