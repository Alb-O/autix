{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (with pkgs; [ gemini-cli-bin ]);
    };
in
{
  autix.aspects.gemini = {
    description = "Gemini CLI tooling.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
