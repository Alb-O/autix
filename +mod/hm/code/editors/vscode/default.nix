_:
let
  hmModule = {
    programs.vscode.enable = true;
  };
in
{
  autix.home.modules.vscode = hmModule;
  autix.home.modules.unfreePackages.vscode = [
    "code"
  ];
}
