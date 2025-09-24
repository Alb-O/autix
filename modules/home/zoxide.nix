_:
let
  hmModule = _: {
    programs.zoxide = {
      enable = true;
    };
  };
in
{
  config = {
    flake.modules.homeManager.zoxide = hmModule;
    autix.home.modules.zoxide = hmModule;
  };
}
