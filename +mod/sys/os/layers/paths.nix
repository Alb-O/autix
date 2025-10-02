{ lib, config, ... }:
let
  inherit (lib) attrByPath mapAttrs;

  inherit (config.autix.os) layerTree;

  buildLayerRefs =
    path: node:
    let
      childrenAttr = attrByPath [ "children" ] { } node;
      modulesAttr = attrByPath [ "modules" ] [ ] node;
      descriptionAttr = attrByPath [ "description" ] "" node;
      children = mapAttrs (name: child: buildLayerRefs (path ++ [ name ]) child) childrenAttr;
    in
    children
    // {
      inherit path;
      modules = modulesAttr;
      description = descriptionAttr;
    };

  layerPaths = mapAttrs (name: node: buildLayerRefs [ name ] node) layerTree;
in
{
  config.autix.os.layerPaths = layerPaths;
}
