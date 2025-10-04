{ lib, config, ... }:
let
  aspectsWithHomeModules = lib.filterAttrs (
    _: aspect: aspect.home.modules != [ ]
  ) config.autix.aspects;
  registry = lib.mapAttrs (_: aspect: {
    imports = aspect.home.modules;
  }) aspectsWithHomeModules;
in
{
  flake.modules.homeManager = registry;
}
