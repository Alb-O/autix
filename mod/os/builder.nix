{ inputs, lib, config, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  helpers = lib.attrByPath [ "autix" "home" "profile" "lib" ] { } config;

  layerModules = config.autix.os.layers;
  hostDefinitions = config.autix.os.hosts;

  modulesForLayers = layerNames:
    lib.concatMap (name: lib.attrByPath [ name ] [ ] layerModules) layerNames;

  homeModulesForHost = { profile, system }:
    if profile == null || !(helpers ? homeManagerModulesForProfile) then
      [ ]
    else
      helpers.homeManagerModulesForProfile {
        profileName = profile;
        inherit system;
      };

  mkDefaultsModule = name: system: {
    networking.hostName = name;
    nixpkgs.hostPlatform = system;
    system.stateVersion = "24.11";
    security.sudo.wheelNeedsPassword = false;
    _module.args.modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
  };

  buildHost = name: host:
    let
      system = host.system;
      profile = lib.attrByPath [ "profile" ] null host;
      layerNames = lib.attrByPath [ "layers" ] [ ] host;
      extraModules = lib.attrByPath [ "modules" ] [ ] host;
      hostModules =
        modulesForLayers layerNames
        ++ extraModules
        ++ homeModulesForHost { inherit profile system; }
        ++ [ mkDefaultsModule name system ];
    in
    nixosSystem {
      inherit system;
      modules = hostModules;
    };

in
{
  flake.nixosConfigurations = lib.mapAttrs buildHost hostDefinitions;
}
