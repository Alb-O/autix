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
      xdg.configFile."kitty/tab_bar.py" = {
        source = ./tab_bar.py;
      };
      programs.kitty = {
        enable = true;

        extraConfig = ''
          font_family family='${fontName}' style='${fontStyle}'
          font_size ${toString fontSize}'';

        settings = {
          shell_integration = "enabled";
          term = "xterm-256color";
          shell = "fish";
          strip_trailing_spaces = "smart";
          focus_follows_mouse = "yes";
          enable_audio_bell = "no";

          # Appearance
          background_opacity = "1.0";
          window_padding_width = "0 20 20";
          cursor_shape = "beam";
          cursor_blink_interval = "0.25";
          hide_window_decorations = "yes";
          active_border_color = "#80c8ff";

          ## Tab bar
          tab_bar_min_tabs = "1";
          tab_bar_edge = "top";
          tab_bar_margin_height = "5.0 5.0";
          tab_bar_style = "custom";
          tab_powerline_style = "round";
          active_tab_foreground = "#000000";
          inactive_tab_foreground = "#1E1E1E";
          active_tab_background = "#BBDDFF";
          inactive_tab_background = "#579DD4";
          tab_bar_margin_color = "#1E1E1E";
          tab_title_template = "{index}: {title}";

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
        };
      };
    };
in
{
  autix.home.modules.kitty = hmModule;
}
