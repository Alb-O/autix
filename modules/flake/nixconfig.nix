{ lib, config, ... }:
let
  inherit (lib) unique flatten mapAttrsToList;
  inherit (config.autix) aspects;

  # Scopes to collect configuration from
  scopes = [
    "home"
    "nixos"
  ];

  # Generic collector for a specific attribute across all scopes and aspects
  collectAttribute =
    attrName:
    unique (
      flatten (mapAttrsToList (_: aspect: map (scope: aspect.${scope}.${attrName} or [ ]) scopes) aspects)
    );
in
{
  flake-file.nixConfig = {
    extra-substituters = collectAttribute "substituters";
    extra-trusted-public-keys = collectAttribute "trustedPublicKeys";
  };
}
