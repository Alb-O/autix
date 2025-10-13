{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    attrByPath
    attrNames
    concatLists
    mapAttrsToList
    optionals
    foldl'
    elem
    ;

  inherit (config.autix) aspects;
  aspectNames = attrNames aspects;

  baseOverlays = foldl' (
    acc: aspectName: acc // (aspects.${aspectName}.overlays or { })
  ) { } aspectNames;

  emptyScope = {
    modules = [ ];
    targets = [ ];
    perTarget = { };
    unfreePackages = [ ];
    substituters = [ ];
    trustedPublicKeys = [ ];
  };

  masterAspectNames = foldl' (
    acc: aspectName:
    let
      scopeHome = attrByPath [ aspectName "home" ] emptyScope aspects;
      scopeNixos = attrByPath [ aspectName "nixos" ] emptyScope aspects;
    in
    if (scopeHome.master or scopeNixos.master) then acc ++ [ aspectName ] else acc
  ) [ ] aspectNames;

  # Only generate overlays for aspects that don't already provide an overlay with the same key.
  existingOverlayKeys = attrNames baseOverlays;

  masterGeneratedOverlaysList = foldl' (
    acc: aspectName:
    if elem aspectName existingOverlayKeys then
      acc
    else
      acc
      ++ [
        {
          name = aspectName;
          value =
            final: _prev:
            let
              pkgs = builtins.getAttr final.system inputs.nixpkgs-master.legacyPackages;
            in
            builtins.listToAttrs [
              {
                name = aspectName;
                value = builtins.getAttr aspectName pkgs;
              }
            ];
        }
      ]
  ) [ ] masterAspectNames;

  masterGeneratedOverlays = builtins.listToAttrs masterGeneratedOverlaysList;

  overlays = baseOverlays // masterGeneratedOverlays;

  emptyPerTarget = {
    modules = [ ];
    unfreePackages = [ ];
    substituters = [ ];
    trustedPublicKeys = [ ];
  };

  matchesTarget = scope: target: (elem "*" scope.targets) || (elem target scope.targets);

  perTargetEntry = scope: target: attrByPath [ target ] emptyPerTarget scope.perTarget;

  # Generic function to collect a specific attribute from aspects
  collectFromScope =
    attrName: scopeName: target:
    concatLists (
      mapAttrsToList (
        _: aspect:
        let
          scope = attrByPath [ scopeName ] emptyScope aspect;
          baseValues = optionals (matchesTarget scope target) (scope.${attrName} or [ ]);
          targetEntry = perTargetEntry scope target;
        in
        baseValues ++ (targetEntry.${attrName} or [ ])
      ) aspects
    );

  modulesForScope = collectFromScope "modules";
  unfreeForScope = collectFromScope "unfreePackages";
  substitutorsForScope = collectFromScope "substituters";
  trustedKeysForScope = collectFromScope "trustedPublicKeys";

  aspectHelpers = {
    inherit
      modulesForScope
      unfreeForScope
      substitutorsForScope
      trustedKeysForScope
      overlays
      ;
  };
in
{
  _module.args.autixAspectHelpers = aspectHelpers;
  flake.overlays = overlays;

  # Conditionally inject the nixpkgs master flake input when at least one
  # aspect requested `master = true`.
  flake-file =
    if (builtins.length masterAspectNames) > 0 then
      {
        inputs = {
          nixpkgs-master.url = "github:NixOS/nixpkgs/master";
        };
      }
    else
      { };
}
