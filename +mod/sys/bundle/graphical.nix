{ lib, ... }:
let
  packages =
    pkgs: with pkgs; [
      hyprpicker
      libinput
      solaar
      vesktop
    ];

  hmModule =
    {
      config,
      pkgs,
      ...
    }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
    in
    lib.mkIf isGraphical {
      home.packages = lib.mkAfter (packages pkgs);
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
