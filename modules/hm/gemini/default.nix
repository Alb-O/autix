_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ gemini-cli-bin ];
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
