_:
let
  hmModule = { pkgs, config, ... }: {
    gtk = {
      enable = true;
      gtk2.configLocation = config.xdg.configHome + "/gtk-2.0/gtkrc";
      font = {
        name = "Fira Sans";
        package = pkgs.fira-sans;
        size = 13;
      };
    };
  };
in
{
  autix.aspects.gtk = {
    description = "GTK settings.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
