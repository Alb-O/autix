_:
let
  hmModule = _: {
    programs.tmux = {
      enable = true;
    };
  };
in
{
  flake.aspects.tmux = {
    description = "Tmux, primarily for agents interactive usage.";
    homeManager = hmModule;
  };
}
