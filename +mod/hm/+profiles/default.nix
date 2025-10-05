{
  lib,
  inputs,
  config,
  autixAspectHelpers,
  ...
}:
let
  inherit (lib)
    attrValues
    mapAttrs
    mkOption
    optionalAttrs
    types
    ;

  inherit (config.autix.home) profiles;

  # Options module that declares the profile metadata schema for HM
  profileOptionsModule = {
    options.autix.home.profile = {
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Name of the active profile.";
      };

      graphical = mkOption {
        type = types.bool;
        default = false;
        description = "Whether this profile targets a graphical session.";
      };

      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
        description = "Target system identifier.";
      };
    };
  };

  profileMetaModule =
    profileName: profile:
    { lib, ... }:
    let
      inherit (lib) mkDefault mkMerge mkIf;
    in
    {
      autix.home.profile = {
        name = profileName;
        inherit (profile) graphical;
        inherit (profile) system;
      };

      home = mkMerge [
        {
          username = mkDefault profile.user;
          stateVersion = mkDefault profile.stateVersion;
        }
        (mkIf (profile.homeDirectory != null) {
          homeDirectory = mkDefault profile.homeDirectory;
        })
      ];
    };

  modulesForProfile =
    profileName: profile:
    [
      profileOptionsModule
      (profileMetaModule profileName profile)
    ]
    ++ autixAspectHelpers.modulesForScope "home" profileName
    ++ profile.extraModules;

  unfreeForProfile =
    profileName: profile:
    autixAspectHelpers.unfreeForScope "home" profileName ++ profile.extraUnfreePackages;

  buildProfile =
    profileName: profile:
    let
      permittedUnfreePackages = unfreeForProfile profileName profile;
      overlays = attrValues autixAspectHelpers.overlays;
      
      # Instantiate nixpkgs with unfree support if needed
      pkgs = import inputs.nixpkgs (
        {
          system = profile.system;
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
      
      modules = modulesForProfile profileName profile;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs modules;
    };
in
{
  flake.homeConfigurations = mapAttrs buildProfile profiles;
  _module.args.autixHomeProfileComputed = {
    inherit modulesForProfile unfreeForProfile;
  };
}
