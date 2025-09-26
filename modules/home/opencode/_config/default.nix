{ lib, pkgs, ... }:
let
  confFiles = [
    ./lsp.nix
    ./formatter.nix
    ./mcp.nix
    ./agent.nix
  ];
  load =
    path:
    let
      v = import path;
    in
    if builtins.isFunction v then v { inherit lib pkgs; } else v;
  confAttrsets = map load confFiles;
  mergedSettings = lib.foldl' lib.recursiveUpdate { } (map (c: c.settings or { }) confAttrsets);
  mergedPackages = lib.unique (lib.concatMap (c: c.packages or [ ]) confAttrsets);
in
{
  settings = mergedSettings;
  packages = mergedPackages;
}
