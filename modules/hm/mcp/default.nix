{ lib, ... }:
let
  computeServerArtifacts = cfg:
    let
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
                      headers =
                        lib.mapAttrs (
                          _: value:
                          if lib.isAttrs value && value ? secret then
                            value.placeholder
                          else
                            value
                        ) server.headers;
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

      secretBindings =
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
                            path = [ "mcp" serverName "headers" headerName ];
                            secret = header.secret;
                            default = header.placeholder;
                          }
                        ]
                      else
                        [ ]
                  )
                  server.headers
            )
            cfg.servers
        );
    in
    {
      inherit serverSettings serverPackages secretBindings;
    };

  hmModule =
    { pkgs, config, ... }:
    let
      cfg = config.autix.mcp;
      artifacts = computeServerArtifacts cfg;
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

        autix.secrets.secrets.mcp = {
          enabled = true;
          bindings = artifacts.secretBindings;
        };

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
      ];
    };
  };
}
