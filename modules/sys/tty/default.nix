_:
let
  nixosModule =
    { fontBundle ? null
    , ...
    }:
    let
      bundle =
        if fontBundle == null then
          builtins.throw "flake.aspects.tty requires the fonts aspect to be included"
        else
          fontBundle;
      displayFont = bundle.roles.displayManager;
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
  flake.aspects.tty = {
    description = "kmscon font defaults for virtual consoles.";
    nixos = nixosModule;
  };
}
