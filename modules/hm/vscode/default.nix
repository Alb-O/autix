_:
let
  hmModule = {
    programs.vscode.enable = true;
  };
in
{
  flake.aspects.vscode = {
    description = "Visual Studio Code (unfree) enablement.";
    homeManager = hmModule;
  };
}
