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
in
{
  config = {
    flake.modules.homeManager.codex = hmModule;
    autix.home.modules.codex = hmModule;
  };
}
