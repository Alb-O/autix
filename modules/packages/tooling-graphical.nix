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

  moduleArgs = {
    autixPackages = {
      tooling = {
        graphical = packages;
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.tooling-graphical-bundle = pkgs.symlinkJoin {
        name = "autix-tooling-graphical";
        paths = packages pkgs;
      };
    };
in
{
  autix.home.modules."tooling-graphical" = hmModule;

  inherit perSystem;

  _module.args = moduleArgs;
}
