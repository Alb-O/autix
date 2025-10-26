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
  flake.aspects.gdm = {
    description = "GNOME Display Manager.";
    nixos = nixosModule;
  };
}
