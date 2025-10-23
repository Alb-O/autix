{ lib, ... }:
let
  serverType =
    lib.types.submodule (
      { name, ... }:
      {
        options = {
          type = lib.mkOption {
            type = lib.types.enum [ "remote" "local" ];
            default = "local";
            description = "Whether ${name} is a remote or local MCP server.";
          };

          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the ${name} MCP server.";
          };

          command = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Command to launch the local MCP server (only used when type = \"local\").";
          };

          url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Remote MCP server endpoint (only used when type = \"remote\").";
          };

          headers = lib.mkOption {
            type = lib.types.attrsOf (lib.types.either lib.types.str (
              lib.types.submodule {
                options = {
                  secret = lib.mkOption {
                    type = lib.types.str;
                    description = "SOPS secret name whose contents will be used for this header value.";
                  };

                  placeholder = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = "Fallback value to use when the secret is not available (e.g. during pure evaluation).";
                  };
                };
              }
            ));
            default = { };
            description = "Headers to send when connecting to the remote MCP server.";
          };

          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Package that provides this MCP server's executable.";
          };
        };
      }
    );
in
{
  options.autix.mcp = {
    servers = lib.mkOption {
      type = lib.types.attrsOf serverType;
      default = { };
      description = "Definitions for MCP servers available to OpenCode.";
    };

    tools = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = { };
      description = "OpenCode tool toggles that depend on MCP servers.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional MCP-related packages to install.";
    };
  };
}
