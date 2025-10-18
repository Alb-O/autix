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
      home.packages = with pkgs;
        [
          # codex likes to run adhoc python scripts
          python314
        ];
    };
in
{
  autix.aspects.codex = {
    description = "Codex CLI tooling.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
      master = true;
    };
  };
}
