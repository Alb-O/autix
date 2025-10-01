{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    {
      config =
        let
          opencodeConf = import ./_config { inherit lib pkgs config; };
        in
        {
          programs.opencode = {
            enable = true;
            inherit (opencodeConf) settings;
          };
          home.packages = lib.mkAfter opencodeConf.packages;
        };
    };
in
{
  autix.home.modules.opencode = hmModule;
}
