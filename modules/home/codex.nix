{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    {
      programs.codex = {
        enable = true;
        settings = {
          approval_policy = "never";
        };
      };
      home.packages = lib.mkAfter (
        with pkgs;
        [
          python314 # codex likes to use python for bulky tasks
        ]
      );
    };
in
{
  autix.home.modules.codex = hmModule;
}
