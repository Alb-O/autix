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
    description = "Google Gemini CLI.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
