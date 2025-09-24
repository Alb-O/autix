{
  lib,
  config,
  pkgs,
  ...
}:
let
  isGraphical = config.autix.home.profile.graphical or false;
  packages = with pkgs; [
    hyprpicker
    vesktop
    solaar
    libinput
  ];
in
{
  flake.modules.homeManager."tooling-graphical" = lib.mkIf isGraphical {
    home.packages = lib.mkAfter packages;
  };
}
