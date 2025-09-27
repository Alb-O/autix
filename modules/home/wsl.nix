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

  autix = {
    home.modules.wsl = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
