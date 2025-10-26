_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ ast-grep ];
    };
in
{
  flake.aspects.ast-grep = {
    description = "Fast and polyglot tool for code searching, linting, rewriting at large scale";
    homeManager = hmModule;
  };
}
