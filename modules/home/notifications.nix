{ lib, config, ... }:
let
  isGraphical = config.autix.home.profile.graphical or false;
  fontChoices = config.fonts.fontconfig.defaultFonts.monospace or [ "JetBrainsMono Nerd Font" ];
  fontName = lib.head fontChoices;
  fontSize = 13;
in
{
  flake.modules.homeManager.notifications = lib.mkIf isGraphical {
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
}
