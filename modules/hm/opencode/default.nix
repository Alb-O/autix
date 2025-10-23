{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    let
      opencodeConf = import ./_config { inherit lib pkgs config; };
      schema = "https://opencode.ai/config.json";
      inherit (opencodeConf) settings;
      hasSettings = settings != { };
      renderedConfig = builtins.toJSON (
        {
          "$schema" = schema;
        }
        // settings
      );
    in
    {
      config = lib.mkMerge [
        {
          sops.secrets."context7/api-key" = { };
          programs.opencode.enable = true;
        }
        (lib.mkIf hasSettings {
          sops.templates."opencode-config" = {
            content = renderedConfig;
            path = "${config.xdg.configHome}/opencode/config.json";
          };
        })
      ];
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
