_:
let
  hmModule =
    { lib, pkgs, ... }:
    {
      home.packages = lib.mkAfter [ pkgs.wslu ];

      home.sessionVariables = {
        WSLENV = lib.mkDefault "NIX_PATH/u";
        BROWSER = lib.mkForce "wslview";
      };

      home.shellAliases = {
        open = "wslview";
      };
    };
in
{
  config = {
    flake.modules.homeManager.wsl = hmModule;
    autix.home.modules.wsl = hmModule;
  };
}
