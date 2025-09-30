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
  autix.home.modules.zoxide = hmModule;
}
