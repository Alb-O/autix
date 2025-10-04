_:
let
  nixosModule = {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "esc";
              esc = "capslock";
            };
          };
        };
      };
    };
  };
in
{
  autix.aspects.keyboard = {
    description = "Swap Caps Lock and Escape via keyd.";
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.keyboard = nixosModule;
}
