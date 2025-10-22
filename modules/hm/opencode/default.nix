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
          sops.secrets."context7/api-key" = { };
          programs.opencode = {
            enable = true;
            inherit (opencodeConf) settings;
          };
          home.packages = opencodeConf.packages;
        };
    };
in
{
  autix.aspects.opencode = {
    description = "OpenCode configuration.";
    home = {
      master = true;
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
