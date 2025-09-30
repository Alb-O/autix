{ inputs, lib, config, ... }:
let
  inherit (lib)
    attrByPath
    hasAttr
    mkAfter
    mkOption
    types;

  hmAspects = attrByPath [ "autix" "home" "modules" ] { } config;

  requireAspect = name:
    attrByPath [ name ] (throw "Home-manager aspect '${name}' is not defined") hmAspects;

  selectAspects = names: map requireAspect names;

  optionsModule = attrByPath [ "flake" "modules" "homeManager" "profileOptions" ] null config;

  baseModuleNames =
    attrByPath [ "autix" "home" "profile" "baseModules" ]
      config.autix.home.profileDefaults.baseModules
      config;

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
        profileDefs = attrByPath [ "autix" "home" "profile" "profiles" ] { } config;
      in if !(hasAttr profileName profileDefs) then
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
            environment.systemPackages = mkAfter [
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

  profileType = types.submodule (
    { name, ... }:
    {
      options = {
        user = mkOption {
          type = types.str;
          description = "User aspect name to include for profile '${name}'.";
        };

        system = mkOption {
          type = types.str;
          default = "x86_64-linux";
          description = "Target system identifier for this profile.";
        };

        graphical = mkOption {
          type = types.bool;
          default = false;
          description = "Whether the profile assumes a graphical session.";
        };

        modules = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional home-manager aspects to include.";
        };
      };
    }
  );

  profileOptionSet = {
    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Identifier for the active home profile.";
    };

    graphical = mkOption {
      type = types.bool;
      default = false;
      description = "Whether the current home profile targets a graphical environment.";
    };

    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "System identifier for this profile's package set.";
    };

    baseModules = mkOption {
      type = types.listOf types.str;
      default = config.autix.home.profileDefaults.baseModules;
      description = "Home-manager aspects included for every profile.";
    };

    profiles = mkOption {
      type = types.attrsOf profileType;
      default = { };
      description = "Declarative set of home profiles available in this flake.";
    };
  };

  profileOptionsModule = {
    options.autix.home.profile = profileOptionSet;
    options.autix.home.modules = mkOption {
      type = types.attrsOf types.raw;
      default = { };
      description = "Registry of home-manager aspect modules keyed by aspect name.";
    };

    config.autix.home.modules.profileOptions = _: { };
  };
in
{ 
  options.autix.home = {
    profile = profileOptionSet;
    modules = mkOption {
      type = types.attrsOf types.raw;
      default = { };
      description = "Registry of home-manager aspect modules keyed by aspect name.";
    };
  };

  options.autix.home.profileSupport = mkOption {
    type = types.raw;
    default = { };
    description = "Helper functions for assembling home profile modules across configuration classes.";
  };

  config.flake.modules.homeManager.profileOptions = _: profileOptionsModule;

  config.autix.home.profileSupport = {
    inherit
      baseModuleNames
      baseModules
      requireAspect
      selectAspects
      profileModules
      homeManagerModulesForProfile
      mkHomeConfiguration;
  };
}
