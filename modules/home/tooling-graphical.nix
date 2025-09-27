_:
let
  hmModule =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
    in
    lib.mkIf isGraphical {
      home.packages = lib.mkAfter (
        with pkgs;
        [
          hyprpicker
          vesktop
          solaar
          libinput
        ]
      );
    };

  autix = {
    home.modules."tooling-graphical" = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
