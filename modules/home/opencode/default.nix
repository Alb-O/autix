{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    let
      opencodeConf = import ./_config { inherit lib pkgs; };
    in
    {
      programs.opencode = {
        enable = true;
        inherit (opencodeConf) settings;
      };
      home.packages = lib.mkAfter opencodeConf.packages;
    };

  autix = {
    home.modules.opencode = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
