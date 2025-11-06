_:
let
  nixosModule =
    { config, ... }:
    let
      fonts = config.autix.fonts;
    in
    {
      services.kmscon = {
        enable = true;
        fonts = [
          {
            inherit (fonts.mono) name;
            inherit (fonts.mono) package;
          }
        ];
        extraConfig = "font-size=18";
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
}
