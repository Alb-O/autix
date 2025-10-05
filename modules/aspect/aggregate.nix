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
    substituters = [ ];
    trustedPublicKeys = [ ];
  };

  # Default empty scope with all possible fields
  emptyScope = {
    modules = [ ];
    targets = [ ];
    perTarget = { };
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

  # Specialized collection functions using the generic collector
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
}
