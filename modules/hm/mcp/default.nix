{ lib, ... }:
let
  headerType =
    lib.types.either lib.types.str (
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
    );

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
            type = lib.types.attrsOf headerType;
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

  hmModule =
    { pkgs, config, ... }:
    let
      cfg = config.autix.mcp;

      resolveHeaderValue =
        value:
        if lib.isString value then
          value
        else if lib.isAttrs value && value ? secret then
          value.placeholder
        else
          throw "autix.mcp: header values must be strings or attrsets containing a `secret` attribute.";

      serverSettings =
        lib.mapAttrs
          (
            _: server:
              let
                base = {
                  inherit (server) type enabled;
                };
                remoteAttrs =
                  if server.type == "remote" then
                    (lib.optionalAttrs (server.url != null) { url = server.url; })
                    // {
                      headers = lib.mapAttrs (_: resolveHeaderValue) server.headers;
                    }
                  else
                    { };
                localAttrs =
                  if server.type == "local" then
                    { command = server.command; }
                  else
                    { };
              in
              base // remoteAttrs // localAttrs
          )
          cfg.servers;

      serverPackages =
        lib.filter (pkg: pkg != null) (
          lib.mapAttrsToList (_: server: server.package) cfg.servers
        );

      secretNames =
        lib.unique (
          lib.flatten (
            lib.mapAttrsToList
              (
                _: server:
                  lib.mapAttrsToList
                    (
                      _: header:
                        if lib.isAttrs header && header ? secret then [ header.secret ] else [ ]
                    )
                    server.headers
              )
              cfg.servers
          )
        );

      secretHeaders =
        lib.flatten (
          lib.mapAttrsToList
            (
              serverName: server:
                lib.mapAttrsToList
                  (
                    headerName: header:
                      if lib.isAttrs header && header ? secret then
                        [
                          {
                            inherit serverName headerName;
                            secretName = header.secret;
                            secretPath = config.sops.secrets."${header.secret}".path;
                          }
                        ]
                      else
                        [ ]
                  )
                  server.headers
            )
            cfg.servers
        );

      secretHeadersJson = builtins.toJSON secretHeaders;
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

        sops.secrets = lib.genAttrs secretNames (_: { });

        programs.opencode.settings = {
          mcp = serverSettings;
          tools = cfg.tools;
        };

        home.packages = lib.unique (serverPackages ++ cfg.packages);

        home.activation.autix-mcp-secrets =
          lib.mkIf (secretHeaders != [ ]) (
            config.lib.dag.entryAfter [ "installSopsSecrets" "writeBoundary" ] ''
                            configFile="${config.xdg.configHome}/opencode/config.json"
                            if [ -f "$configFile" ]; then
                              MCP_SECRET_HEADERS=${lib.escapeShellArg secretHeadersJson} \
                              CONFIG_FILE="$configFile" \
                              ${pkgs.python3}/bin/python - <<'PY'
              import json
              import os
              import pathlib

              config_path = pathlib.Path(os.environ["CONFIG_FILE"])

              try:
                  data = json.loads(config_path.read_text())
              except FileNotFoundError:
                  raise SystemExit(0)
              except json.JSONDecodeError:
                  raise SystemExit(0)

              changed = False

              for item in json.loads(os.environ["MCP_SECRET_HEADERS"]):
                  secret_path = pathlib.Path(item["secretPath"])
                  try:
                      secret_value = secret_path.read_text().strip()
                  except FileNotFoundError:
                      continue

                  server = data.setdefault("mcp", {}).setdefault(item["serverName"], {})
                  headers = server.setdefault("headers", {})
                  if headers.get(item["headerName"]) != secret_value:
                      headers[item["headerName"]] = secret_value
                      changed = True

              if changed:
                  config_path.write_text(json.dumps(data, indent=2) + "\n")
              PY
                            fi
            ''
          );
      };
    };

  optionsModule = {
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
  };
in
{
  autix.aspects.mcp = {
    description = "Model Context Protocol settings and tooling.";
    home = {
      targets = [ "*" ];
      modules = [
        optionsModule
        hmModule
      ];
    };
  };
}
