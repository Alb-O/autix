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
    mkDefault
    mkOption
    optionalAttrs
    types
    ;

  inherit (config.autix.home) profiles;

  # Single module that declares AND sets profile metadata
  profileMetaModule =
    profileName: profile:
    { ... }:
    {
      options.autix.home.profile = {
        name = mkOption {
          type = types.str;
          default = profileName;
          readOnly = true;
          description = "Profile name (read-only).";
        };

        graphical = mkOption {
          type = types.bool;
          default = profile.graphical;
          readOnly = true;
          description = "Whether profile targets a graphical session (read-only).";
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
          system = profile.system;
          inherit overlays;
        }
        // optionalAttrs (permittedUnfreePackages != [ ]) {
          config = {
            allowUnfree = true;
            inherit permittedUnfreePackages;
            allowUnfreePredicate = pkg: 
              builtins.elem (inputs.nixpkgs.lib.getName pkg) permittedUnfreePackages;
          };
        }
      );
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = modulesForProfile profileName profile;
    };
in
{
  flake.homeConfigurations = mapAttrs buildProfile profiles;
  _module.args.autixHomeProfileComputed = {
    inherit modulesForProfile;
  };
}
