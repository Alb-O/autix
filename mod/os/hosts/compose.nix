{ inputs, lib, config, ... }:
let
  inherit (lib)
    attrByPath
    concatStringsSep
    foldl'
    mapAttrs;

  nixosSystem = inputs.nixpkgs.lib.nixosSystem;

  layerTree = config.autix.os.layerTree;
  hostDefinitions = config.autix.os.hosts;
  helpers = config.autix.home.profileSupport;

  pathKey = path: concatStringsSep "/" path;

  collectFromNode = pathSoFar: node: remaining: visited: modules:
    let
      key = pathKey pathSoFar;
      alreadyVisited = lib.elem key visited;
      visited' = if alreadyVisited then visited else visited ++ [ key ];
      nodeModules = attrByPath [ "modules" ] [ ] node;
      modules' = if alreadyVisited then modules else modules ++ nodeModules;
    in
    if remaining == [ ] then
      {
        visited = visited';
        modules = modules';
      }
    else
      let
        childName = builtins.head remaining;
        children = attrByPath [ "children" ] { } node;
        childNode =
          attrByPath [ childName ]
            (throw "Layer '${childName}' is not defined under path '${pathKey pathSoFar}'")
            children;
      in
      collectFromNode (pathSoFar ++ [ childName ]) childNode (builtins.tail remaining) visited' modules';

  collectPath = path: state:
    if path == [ ] then state
    else
      let
        rootName = builtins.head path;
        rootNode =
          attrByPath [ rootName ]
            (throw "Layer '${rootName}' is not defined in the OS layer tree")
            layerTree;
        remainder = builtins.tail path;
        result = collectFromNode [ rootName ] rootNode remainder state.visited state.modules;
      in
      {
        visited = result.visited;
        modules = result.modules;
      };

  modulesForPaths = paths:
    (foldl'
      (state: path: collectPath path state)
      { visited = [ ]; modules = [ ]; }
      paths
    ).modules;

  mkHost = name: host:
    let
      layerModules = modulesForPaths host.paths;
      modules = layerModules ++ host.extraModules;
      hmModules = helpers.homeManagerModulesForProfile {
        profileName = host.profile;
        system = host.system;
      };
      defaultsModule = {
        networking.hostName = name;
        nixpkgs.hostPlatform = host.system;
        system.stateVersion = host.stateVersion;
        security.sudo.wheelNeedsPassword = false;
        _module.args.modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
      };
    in
    nixosSystem {
      system = host.system;
      modules = modules ++ hmModules ++ [ defaultsModule ];
    };

in
{
  flake.nixosConfigurations = mapAttrs mkHost hostDefinitions;
}
