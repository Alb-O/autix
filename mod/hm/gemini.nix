{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkAfter (with pkgs; [ gemini-cli-bin ]);
    };
in
{
  autix.home.modules.gemini = hmModule;
}
