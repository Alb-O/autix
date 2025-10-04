_:
let
  nixosModule =
    { config, ... }:
    let
      fontBundle = config.autix.fonts;
      displayFont = fontBundle.roles.displayManager;
      monoFamily = displayFont.family;
    in
    {
      services.kmscon = {
        enable = true;
        fonts = [
          {
            inherit (monoFamily) name;
            inherit (monoFamily) package;
          }
        ];
        extraConfig = "font-size=${toString displayFont.size}";
      };
    };
in
{
  autix.aspects.tty = {
    description = "kmscon font defaults for virtual consoles.";
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.tty = nixosModule;
}
