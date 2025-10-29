_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nodejs ];
    };
in
{
  autix.aspects.node = {
    description = "NodeJS";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
