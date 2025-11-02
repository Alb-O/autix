_:
let
  niriConfig = builtins.readFile ./config.kdl;
  hmModule =
    { pkgs, ... }:
    {
      xdg.configFile."niri/config.kdl" = {
        enable = true;
        source = pkgs.writeText "niri-config.kdl" niriConfig;
      };
    };

  nixosModule =
    { pkgs
    , ...
    }:
    {
      programs.niri = {
        enable = true;
      };
      environment.systemPackages = [ pkgs.alacritty ];
    };
in
{
  autix.aspects.niri = {
    description = "Niri Wayland compositor and related tooling.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };
}
