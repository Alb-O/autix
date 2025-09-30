{ lib, pkgs }:
let
  # Import each plugin module (every *.nix except default.nix) and turn it into an attr set keyed by plugin name.
  pluginFiles = lib.filter (file: file != "default.nix" && lib.hasSuffix ".nix" file) (
    builtins.attrNames (builtins.readDir ./.)
  );

  mergeKeymapSets =
    lhs: rhs:
    if lhs == null then
      rhs
    else if rhs == null then
      lhs
    else if lib.isList lhs && lib.isList rhs then
      lhs ++ rhs
    else if lib.isAttrs lhs && lib.isAttrs rhs then
      let
        keys = lib.unique ((builtins.attrNames lhs) ++ (builtins.attrNames rhs));
      in
      lib.genAttrs keys (
        key: mergeKeymapSets (lib.attrByPath [ key ] null lhs) (lib.attrByPath [ key ] null rhs)
      )
    else
      rhs;

  pluginDefs = lib.listToAttrs (
    map (
      file:
      let
        modulePath = builtins.toString ./. + "/" + file;
        module = import modulePath { inherit lib pkgs; };
        name = module.name or (lib.removeSuffix ".nix" file);
        value = lib.removeAttrs module [ "name" ];
      in
      {
        inherit name value;
      }
    ) pluginFiles
  );

  plugins = lib.mapAttrs (_: cfg: cfg.package) pluginDefs;
  pluginSettings = builtins.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList (_: cfg: cfg.settings or { }) pluginDefs
  );
  pluginExtraPackages = lib.concatLists (
    lib.mapAttrsToList (_: cfg: cfg.extraPackages or [ ]) pluginDefs
  );
  pluginSetupOptions = lib.filterAttrs (_: opts: opts != null && opts != { }) (
    lib.mapAttrs (_: cfg: cfg.setupOptions or { }) pluginDefs
  );
  pluginKeymap = builtins.foldl' (acc: cfg: mergeKeymapSets acc (cfg.keymap or { })) { } (
    lib.attrValues pluginDefs
  );
in
{
  inherit
    plugins
    pluginSettings
    pluginExtraPackages
    pluginSetupOptions
    pluginKeymap
    ;
}
