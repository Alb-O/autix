{ lib, ... }:
let
  hmModule =
    { config, ... }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
      fontBundle = config.autix.fonts;
      terminalFont = fontBundle.roles.terminal;
      fontName = terminalFont.family.name;
      fontSize = terminalFont.size;
      fontStyle = terminalFont.family.style;
    in
    lib.mkIf isGraphical {
      programs.kitty = {
        enable = true;

        extraConfig = ''
          font_family family='${fontName}' style='${fontStyle}'
          font_size=${toString fontSize}'';

        settings = {
          # Terminal behavior
          shell_integration = "enabled";
          term = "xterm-256color";
          shell = "fish";

          # Appearance
          background_opacity = "1.0";
          window_padding_width = "25 20";
          cursor_shape = "beam";
          cursor_blink_interval = "0.25";
          hide_window_decorations = "yes";

          # Gruvdark color scheme
          foreground = "#E6E3DE";
          background = "#1E1E1E";
          selection_background = "#2A404F";
          cursor = "#E6E3DE";
          url_color = "#579DD4";

          # Normal colors
          color0 = "#1E1E1E";
          color1 = "#E16464";
          color2 = "#72BA62";
          color3 = "#D19F66";
          color4 = "#579DD4";
          color5 = "#9266DA";
          color6 = "#00A596";
          color7 = "#D6CFC4";

          # Bright colors
          color8 = "#9D9A94";
          color9 = "#F19A9A";
          color10 = "#9AD58B";
          color11 = "#E6BB88";
          color12 = "#8AC0EA";
          color13 = "#B794F0";
          color14 = "#2FCAB9";
          color15 = "#E6E3DE";

          # Window layout
          remember_window_size = "no";
          initial_window_width = "640";
          initial_window_height = "400";

          # Performance
          repaint_delay = "10";
          input_delay = "3";
          sync_to_monitor = "yes";
        };
      };
    };

  autix = {
    home.modules.kitty = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
