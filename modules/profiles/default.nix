{ lib
, inputs
, config
, autixAspectHelpers
, ...
}:
let
  inherit (lib)
    attrValues
    mapAttrs
    mkDefault
    mkOption
    optionalAttrs
    types
    ;

  inherit (config.autix.home) profiles;
  # TODO: wire this up to `autix.home.legacyBuilder.enable` once
  # coexistence with den's home builder is solved.
  legacyBuilderEnabled = false;

  # Single module that declares AND sets profile metadata
  profileMetaModule = profileName: profile: _: {
    options.autix.home.profile = {
      name = mkOption {
        type = types.str;
        default = profileName;
        readOnly = true;
        description = "Profile name (read-only).";
      };

      system = mkOption {
        type = types.str;
        default = profile.system;
        readOnly = true;
        description = "Target system architecture (read-only).";
      };
    };

    config = {
      home.username = mkDefault profile.user;
    };
  };

  modulesForProfile =
    profileName: profile:
    if !(profile.buildWithLegacyHomeManager or true) then
      [ ]
    else
      [ (profileMetaModule profileName profile) ]
      ++ autixAspectHelpers.modulesForScope "home" profileName
      ++ profile.extraModules;

  buildProfile =
    profileName: profile:
    let
      overlays = attrValues autixAspectHelpers.overlays;
      permittedUnfreePackages = autixAspectHelpers.unfreeForScope "home" profileName;

      pkgs = import inputs.nixpkgs (
        {
          inherit (profile) system;
          inherit overlays;
        }
        // optionalAttrs (permittedUnfreePackages != [ ]) {
          config = {
            allowUnfree = true;
            inherit permittedUnfreePackages;
            allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) permittedUnfreePackages;
          };
        }
      );
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = modulesForProfile profileName profile;
    };
in
(
  {
    _module.args.autixHomeProfileComputed = {
      inherit modulesForProfile;
    };
  }
    // lib.optionalAttrs legacyBuilderEnabled (
    let
      legacyProfiles = lib.filterAttrs (_: profile: profile.buildWithLegacyHomeManager) profiles;
    in
    lib.optionalAttrs (legacyProfiles != { }) {
      flake.homeConfigurations = mapAttrs buildProfile legacyProfiles;
    }
  )
)
