{ inputs, lib, ... }:
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
          programs.opencode = {
            package = inputs.opencode-flake.packages."${pkgs.system}".default;
            enable = true;
          };
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
  flake-file = {
    inputs.opencode-flake = {
      url = "github:Alb-O/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.opencode = {
    description = "My OpenCode Flake.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
