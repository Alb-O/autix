{ ... }:
let
  hmModule =
    { lib, pkgs, ... }:
    {
      home.packages = lib.mkAfter (with pkgs; [ vscode-fhs ]);
    };
in
{
  autix.home.modules.vscode = hmModule;
  autix.home.modules.unfreePackages.vscode = [
    "code"
  ];
}
