{ inputs
, lib
, config
, autixAspectHelpers
, autixHomeProfileComputed
, ...
}:
let
  inherit (lib)
    hasAttr
    mapAttrs
    mkAfter
    ;

  inherit (config.autix.os) hosts;
  inherit (config.autix.home) profiles;

  ensureProfile =
    profileName:
    if hasAttr profileName profiles then
      profiles.${profileName}
    else
      throw "Home profile '${profileName}' is not defined";

  homeManagerModulesForHost =
    _hostName: host:
    if host.profile == null then
      [ ]
    else
      let
        profileName = host.profile;
        profile = ensureProfile profileName;
      in
      if !(profile.buildWithLegacyHomeManager or true) then
        [ ]
      else
        let
          userName = profile.user;
          hmModules = autixHomeProfileComputed.modulesForProfile profileName profile;
        in
        [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userName}.imports = hmModules;
            };
            environment.systemPackages = mkAfter [
              inputs.home-manager.packages.${host.system}.home-manager
            ];
          }
        ];

  defaultsModule = hostName: host: {
    networking.hostName = hostName;
    nixpkgs.hostPlatform = host.system;
    system.stateVersion = host.stateVersion;
    security.sudo.wheelNeedsPassword = false;
  };

  modulesForHost =
    hostName: host:
    let
      aspectModules = autixAspectHelpers.modulesForScope "nixos" hostName;
      hmModules = homeManagerModulesForHost hostName host;
      allModules = [ (defaultsModule hostName host) ] ++ aspectModules ++ hmModules ++ host.extraModules;
    in
    allModules;

  mkHost =
    hostName: host:
    let
      modules = modulesForHost hostName host;
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit (host) system;
      inherit modules;
    };
in
{
  flake.nixosConfigurations = mapAttrs mkHost hosts;
}
