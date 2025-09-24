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
in
{
  config = {
    flake.modules.homeManager."tooling-graphical" = hmModule;
    autix.home.modules."tooling-graphical" = hmModule;
  };
}
