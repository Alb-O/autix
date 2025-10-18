{ inputs, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.git-sparta.packages.${pkgs.system}.git-sparta
      ];
    };
in
{
  flake-file = {
    inputs = {
      git-sparta.url = "github:Alb-O/git-sparta";
      git-sparta.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.git-sparta = {
    description = "git-sparta CLI integration for git attribute sparse workflows & tagging.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
