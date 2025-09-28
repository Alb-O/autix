{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (with pkgs; [ gemini-cli-bin ]);
    };

  autix = {
    home.modules.gemini = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
