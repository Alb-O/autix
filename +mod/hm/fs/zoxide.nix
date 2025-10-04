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
  autix.aspects.zoxide = {
    description = "Enable zoxide jump navigation.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
