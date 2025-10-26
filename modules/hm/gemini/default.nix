_:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ gemini-cli-bin ];
    };
in
{
  flake.aspects.gemini = {
    description = "Google Gemini CLI.";
    homeManager = hmModule;
  };
}
