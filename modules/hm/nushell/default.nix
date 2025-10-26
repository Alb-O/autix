_:
let
  hmModule = {
    programs.nushell.enable = true;
  };
in
{
  flake.aspects.nushell = {
    description = "Nushell - A new type of shell.";
    homeManager = hmModule;
  };
}
