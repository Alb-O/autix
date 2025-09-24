{ lib, ... }:
let
  inherit (lib) mkOption types;

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

    profiles = mkOption {
      type = types.attrsOf profileType;
      default = { };
      description = "Declarative set of home profiles available in this flake.";
    };
  };

  profileOptionsModule = {
    options.autix.home.profile = profileOptionSet;
  };
in
{
  options.autix.home.profile = profileOptionSet;

  config.flake.modules.homeManager.profileOptions = _: profileOptionsModule;
}
