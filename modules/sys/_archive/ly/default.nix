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
  flake.aspects.ly = {
    description = "Ly TTY display manager.";
    nixos = nixosModule;
  };
}
