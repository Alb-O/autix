_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ ast-grep ];
    };
in
{
  autix.aspects.ast-grep = {
    description = "Fast and polyglot tool for code searching, linting, rewriting at large scale";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
