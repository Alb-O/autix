{ lib, ... }:
let
  hmModule =
    { config, ... }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
      fontBundle = config.autix.fonts;
      notificationFont = fontBundle.roles.notifications;
      fontName = notificationFont.family.name;
      fontSize = notificationFont.size;
    in
    lib.mkIf isGraphical {
      services.mako = {
        enable = true;
        settings = {
          font = "${fontName} ${builtins.toString fontSize}";
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

  autix = {
    home.modules.notifications = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
