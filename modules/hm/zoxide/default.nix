_:
let
  hmModule = _: {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
in
{
  flake.aspects.zoxide = {
    description = "Enable zoxide jump navigation.";
    homeManager = hmModule;
  };
}
