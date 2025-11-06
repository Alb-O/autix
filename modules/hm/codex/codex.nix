_:
let
  hmModule =
    { pkgs, ... }:
    {
      programs.codex = {
        enable = true;
        # settings = {
        #   approval_policy = "never";
        # };
      };
      home.packages = with pkgs; [
        # codex likes to run adhoc python scripts
        python314
      ];
    };
in
{
  autix.aspects.codex = {
    description = "OpenAI's Codex CLI";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
      # Build times are painful on master with no cache
      # master = true;
    };
  };
}
