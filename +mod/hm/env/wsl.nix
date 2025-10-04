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
  autix.aspects.wsl = {
    description = "WSL integration helpers.";
    home = {
      targets = [ "albert-wsl" ];
      modules = [ hmModule ];
    };
  };
}
