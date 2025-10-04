_:
let
  hmModule = {
    programs.vscode.enable = true;
  };
in
{
  autix.aspects.vscode = {
    description = "Visual Studio Code (unfree) enablement.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
      unfreePackages = [ "code" ];
    };
  };
}
