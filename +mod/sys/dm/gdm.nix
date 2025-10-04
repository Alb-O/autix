_:
let
  nixosModule =
    _:
    {
      services.displayManager = {
        enable = true;
        gdm = {
          enable = true;
        };
      };
    };
in
{
  autix.aspects.dm = {
    description = "GDM display manager.";
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.dm = nixosModule;
}
