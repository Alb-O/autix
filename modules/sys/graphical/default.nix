_:
let
  packages =
    pkgs: with pkgs; [
      hyprpicker
      libinput
      solaar
    ];

  hmModule =
    {
      pkgs,
      ...
    }:
    {
      home.packages = packages pkgs;
    };
in
{
  autix.aspects.graphical = {
    description = "Graphical desktop utilities bundle.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
