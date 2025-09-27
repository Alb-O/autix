_:
let
  hmModule = _: {
    programs.codex = {
      enable = true;
      settings = {
        approval_policy = "never";
      };
    };
  };

  autix = {
    home.modules.codex = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
