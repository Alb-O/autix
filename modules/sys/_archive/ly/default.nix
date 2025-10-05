_:
let
  nixosModule = {
    services.displayManager = {
      enable = true;
      ly = {
        enable = true;
        settings = {
          animation = "matrix";
        };
      };
    };
  };
in
{
  autix.aspects.ly = {
    description = "Ly TTY display manager.";
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };
}
