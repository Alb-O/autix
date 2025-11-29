{
  lib,
  pkgs,
  config,
  ...
}:
let
  confFiles = [
    ./lsp.nix
    ./formatter.nix
    ./mcp.nix
    ./agent.nix
    ./plugin.nix
  ];
  load =
    path:
    let
      v = import path;
    in
    if builtins.isFunction v then v { inherit lib pkgs config; } else v;
  confAttrsets = map load confFiles;
  mergedSettings = lib.foldl' lib.recursiveUpdate { } (map (c: c.settings or { }) confAttrsets);
in
{
  settings = mergedSettings;
}
