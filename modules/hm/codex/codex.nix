_:
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
      home.packages = with pkgs; [
        # codex likes to run adhoc python scripts
        python314
      ];
    };
in
{
  flake.aspects.codex = {
    description = "Codex CLI tooling.";
    homeManager = hmModule;
  };
}
