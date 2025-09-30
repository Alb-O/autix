{ inputs, lib, config, ... }:
let
  hmAspects = lib.attrByPath [ "autix" "home" "modules" ] { } config;

  requireAspect = name:
    lib.attrByPath [ name ] (throw "Home-manager aspect '${name}' is not defined") hmAspects;

  optionsModule = lib.attrByPath [ "flake" "modules" "homeManager" "profileOptions" ] null config;

  baseModuleNames =
    lib.attrByPath [ "autix" "home" "profile" "baseModules" ] [ ] config;

  selectAspects = names: map requireAspect names;

  baseModules =
    (lib.optional (optionsModule != null) optionsModule)
    ++ selectAspects baseModuleNames;

  profileModules = profileName: profile:
    let
      aspectModules = selectAspects profile.modules;
      userModule = requireAspect profile.user;
      profileSettings = _: {
        autix.home.profile = {
          name = profileName;
          inherit (profile) graphical system;
        };
      };
    in
    baseModules
    ++ aspectModules
    ++ [
      userModule
      profileSettings
    ];

  homeManagerModulesForProfile =
    { profileName ? null, system }:
    if profileName == null then
      [ ]
    else
      let
        profileDefs = lib.attrByPath [ "autix" "home" "profile" "profiles" ] { } config;
      in if !(lib.hasAttr profileName profileDefs) then
        throw "Home profile '${profileName}' is not defined"
      else
        let
          profile = profileDefs.${profileName};
          userName = profile.user;
          hmModules = profileModules profileName profile;
        in
        [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userName}.imports = hmModules;
            };
            environment.systemPackages = lib.mkAfter [
              inputs.home-manager.packages.${system}.home-manager
            ];
          }
        ];

  mkHomeConfiguration =
    profileName: profile:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${profile.system};
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = profileModules profileName profile;
    };

  helperLib = {
    inherit
      requireAspect
      selectAspects
      baseModuleNames
      baseModules
      profileModules
      homeManagerModulesForProfile
      mkHomeConfiguration;
  };

in
{
  config.autix.home.profile.lib = helperLib;
}
