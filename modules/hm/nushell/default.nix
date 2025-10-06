{ ... }:
let
  hmModule = {
    programs.nushell.enable = true;
  };
in
{
  autix.aspects.nushell = {
    description = "Nushell - A new type of shell.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
