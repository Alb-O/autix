_:
let
  hmModule = {
    programs.claude-code.enable = true;
  };
in
{
  autix.aspects.claude = {
    description = "Claude Code CLI";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
      master = true;
      unfreePackages = [ "claude" ];
    };
  };
}
