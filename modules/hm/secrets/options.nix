{ lib, ... }:
let
  secretValueType =
    lib.types.either lib.types.str (
      lib.types.submodule {
        options = {
          secret = lib.mkOption {
            type = lib.types.str;
            description = "SOPS secret name whose contents will be used for this value.";
          };

          placeholder = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Fallback value to use when the secret is not available (e.g. during pure evaluation).";
          };
        };
      }
    );

  secretType =
    lib.types.submodule (
      { name, ... }:
      {
        options = {
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the ${name} secret configuration.";
          };

          values = lib.mkOption {
            type = lib.types.attrsOf secretValueType;
            default = { };
            description = "Secret values that can be injected into configurations.";
          };

          bindings = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  path = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Configuration path where the secret should be injected.";
                  };

                  secret = lib.mkOption {
                    type = lib.types.str;
                    description = "SOPS secret name to bind to this path.";
                  };

                  default = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = "Fallback value when the secret is not available.";
                  };
                };
              }
            );
            default = [ ];
            description = "Explicit secret bindings to configuration paths.";
          };
        };
      }
    );
in
{
  options.autix.secrets = {
    secrets = lib.mkOption {
      type = lib.types.attrsOf secretType;
      default = { };
      description = "Secret configurations available for injection.";
    };
  };

  options.autix.secretsHelpers = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {
      computeSecretArtifacts = cfg: builtins.throw "autix.secretsHelpers.computeSecretArtifacts is not available — ensure the secrets aspect is enabled.";
    };
    description = "Runtime helper functions published by the secrets helpers module (placeholder defaults provided).";
  };
}
