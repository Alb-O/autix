_:
let
  nixosModule = _: {
    services.displayManager = {
      enable = true;
      gdm = {
        enable = true;
      };
    };
  };
in
{
  autix.aspects.gdm = {
    description = "GNOME Display Manager.";
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };
}
