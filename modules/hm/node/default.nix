_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nodejs ];
    };
in
{
  autix.aspects.gemini = {
    description = "NodeJS";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
