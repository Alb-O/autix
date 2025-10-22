_:
let
  hmModule = _: {
    programs.tmux = {
      enable = true;
    };
  };
in
{
  autix.aspects.tmux = {
    description = "Tmux, primarily for agents interactive usage.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
