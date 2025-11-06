{ inputs, ... }:
let
  hmModule =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      pruneValue =
        value:
        if builtins.isAttrs value then
          let
            pruned = lib.filterAttrs (_: v: v != null) (lib.mapAttrs (_: pruneValue) value);
          in
          if pruned == { } then null else pruned
        else if builtins.isList value then
          let
            prunedList = builtins.filter (v: v != null) (builtins.map pruneValue value);
          in
          if prunedList == [ ] then null else prunedList
        else if builtins.isString value && value == "" then
          null
        else if value == null then
          null
        else
          value;

      pruneMcpServer = server: lib.filterAttrs (_: v: v != null) (lib.mapAttrs (_: pruneValue) server);
    in
    {
      options.autix.mcp = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (_: {
            options = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "local"
                  "remote"
                ];
                description = "Type of MCP server connection.";
              };
              url = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "URL for remote MCP servers.";
              };
              headers = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "Headers for remote MCP servers.";
              };
              command = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Command for local MCP servers.";
              };
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether this MCP server is enabled.";
              };
            };
          })
        );
        default = { };
        apply = lib.mapAttrs (_: pruneMcpServer);
        description = "MCP server configurations.";
      };

      config =
        let
          hasContext7Secret = config.sops.secrets ? "context7/api-key";
        in
        {
          autix.mcp.context7 =
            let
              context7Placeholder = lib.attrByPath [ "context7/api-key" ] null config.sops.placeholder;
            in
            lib.mkIf (hasContext7Secret && context7Placeholder != null) {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
              headers = {
                "CONTEXT7_API_KEY" = context7Placeholder;
              };
              enabled = true;
            };
          autix.mcp.mcp-nixos = {
            type = "local";
            command = [ "mcp-nixos" ];
            enabled = true;
          };

          home.packages = with pkgs; [
            mcp-nixos
          ];
        };
    };
in
{
  flake-file.inputs.mcp-servers-nix = {
    url = "github:natsukium/mcp-servers-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  autix.aspects.mcp = {
    description = "MCP Servers configuration.";
    overlays.mcp = inputs.mcp-servers-nix.overlays.default;
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
