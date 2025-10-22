{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    let
      cfg = config.autix.mcp;
      artifacts = config.autix.mcpHelpers.computeServerArtifacts cfg;
    in
    {
      config = {
        autix.mcp = {
          servers = {
            context7 = {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
              headers."CONTEXT7_API_KEY" = { secret = "context7/api-key"; };
              enabled = true;
            };

            "mcp-nixos" = {
              type = "local";
              command = [ "mcp-nixos" ];
              package = pkgs.mcp-nixos;
              enabled = true;
            };
          };

          tools = {
            "Mcp-Nixos*" = false;
          };

          packages = [ ];
        };

        sops.secrets = lib.genAttrs artifacts.secretNames (_: { });

        autix.opencode = {
          settings = {
            mcp = artifacts.serverSettings;
            tools = cfg.tools;
          };

          packages = artifacts.serverPackages ++ cfg.packages;
          secretBindings = artifacts.secretBindings;
        };
      };
    };

  optionsModule = import ./options.nix { inherit lib; };
in
{
  autix.aspects.mcp = {
    description = "Model Context Protocol settings and tooling.";
    home = {
      targets = [ "*" ];
      modules = [
        optionsModule
        hmModule
        ./helpers.nix
      ];
    };
  };
}
