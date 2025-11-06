_:
let
  hmModule =
    { config, ... }:
    {
      services.mako = {
        enable = true;
        settings = {
          width = 400;
          height = 150;
          margin = "10";
          padding = "15";
          border-size = 2;
          border-radius = 0;
          default-timeout = 5000;
          ignore-timeout = true;
          layer = "overlay";
          anchor = "top-right";
        };
      };
    };
in
{
  autix.aspects.mako = {
    description = "Mako notification daemon for graphical profiles.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
