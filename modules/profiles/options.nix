{ lib, ... }:
let
  inherit (lib) mkOption types;

  profileType = types.submodule (
    { name, ... }:
    {
      options = {
        user = mkOption {
          type = types.str;
          description = "Primary user account.";
        };

        system = mkOption {
          type = types.str;
          default = "x86_64-linux";
          description = "Target system architecture.";
        };

        extraModules = mkOption {
          type = types.listOf types.raw;
          default = [ ];
          description = "Additional modules appended after aspect modules.";
        };

        buildWithLegacyHomeManager = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to build this profile using the legacy autix home-manager pipeline.";
        };

        aspect = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Primary aspect name when building this profile with flake-aspects/den.";
        };

        den = mkOption {
          type = types.submodule {
            options = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable exporting this profile as a den home.";
              };

              description = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Optional description for the generated den home.";
              };

              extraConfig = mkOption {
                type = types.attrsOf types.anything;
                default = { };
                description = "Additional configuration to merge into the generated den home.";
              };
            };
          };
          default = { };
          description = "den integration settings for this profile.";
        };
      };
    }
  );
in
{
  options.autix.home.legacyBuilder.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Enable the legacy autix Home Manager builder that populates `flake.homeConfigurations`.";
  };

  options.autix.home.profiles = mkOption {
    type = types.attrsOf profileType;
    default = { };
    description = "Declarative Home Manager profiles keyed by name.";
  };
}
