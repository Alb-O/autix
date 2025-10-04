{ lib, config, ... }:
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

  overlays = foldl' (acc: aspectName: acc // (aspects.${aspectName}.overlays or { })) { } aspectNames;

  emptyPerTarget = {
    modules = [ ];
    unfreePackages = [ ];
  };

  matchesTarget = scope: target: (elem "*" scope.targets) || (elem target scope.targets);

  perTargetEntry = scope: target: attrByPath [ target ] emptyPerTarget scope.perTarget;

  modulesForScope =
    scopeName: target:
    concatLists (
      mapAttrsToList (
        _: aspect:
        let
          scope = attrByPath [ scopeName ] {
            modules = [ ];
            targets = [ ];
            perTarget = { };
            unfreePackages = [ ];
          } aspect;
          baseModules = optionals (matchesTarget scope target) scope.modules;
          targetEntry = perTargetEntry scope target;
        in
        baseModules ++ targetEntry.modules
      ) aspects
    );

  unfreeForScope =
    scopeName: target:
    concatLists (
      mapAttrsToList (
        _: aspect:
        let
          scope = attrByPath [ scopeName ] {
            modules = [ ];
            targets = [ ];
            perTarget = { };
            unfreePackages = [ ];
          } aspect;
          basePkgs = optionals (matchesTarget scope target) scope.unfreePackages;
          targetEntry = perTargetEntry scope target;
        in
        basePkgs ++ targetEntry.unfreePackages
      ) aspects
    );

  aspectHelpers = {
    inherit modulesForScope unfreeForScope;
    inherit overlays;
    inherit aspectNames;
  };
in
{
  _module.args.autixAspectHelpers = aspectHelpers;

  flake.overlays = overlays;
}
