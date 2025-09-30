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
  autix.home.modules."tooling-graphical" = hmModule;
}
