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
                            default =
                              if lib.isAttrs header && header ? secret then
                                header.placeholder
                              else
                                header;
                          }
                        ]
                      else
                        [ ]
                  )
                  server.headers
            )
            cfg.servers
        );

      secretNames = lib.unique (map (binding: binding.secret) secretBindings);
    in
    {
      serverSettings = serverSettings;
      serverPackages = serverPackages;
      secretBindings = secretBindings;
      secretNames = secretNames;
    };

  placeholderFor = secret: "<SOPS:" + builtins.hashString "sha256" secret + ":PLACEHOLDER>";
in
{
  config = {
    autix.mcpHelpers = {
      inherit computeServerArtifacts placeholderFor;
    };
  };
}
