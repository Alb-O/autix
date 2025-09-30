{ lib, ... }:
let
  inherit (lib) mkOption types;

  layerType = types.submodule (
    { name, ... }:
    {
      options = {
        modules = mkOption {
          type = types.listOf types.raw;
          default = [ ];
          description = "Ordered NixOS modules that compose the '${name}' layer.";
        };

        description = mkOption {
          type = types.str;
          default = "";
          description = "Human readable summary for the '${name}' layer.";
        };

        children = mkOption {
          type = types.lazyAttrsOf layerType;
          default = { };
          description = "Nested layers that refine '${name}'.";
        };
      };
    }
  );
in
{
  options.autix.os.layerTree = mkOption {
    type = types.attrsOf layerType;
    default = { };
    description = "Hierarchical tree of reusable NixOS layer modules.";
  };
}
