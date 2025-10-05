{ lib, config, ... }:
{
  settings = {
    # LSPs managed by the centralized lsp.nix module
    lsp = lib.mapAttrs (_name: server: {
      inherit (server) command extensions;
    }) config.autix.lsp.servers;
  };
}
