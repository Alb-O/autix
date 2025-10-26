{ lib, ... }:
let
  inherit (lib) mkOption types;

  hostType = types.submodule (
    { name, ... }:
    {
      options = {
        system = mkOption {
          type = types.str;
          description = "Target system identifier for host '${name}'.";
        };

        profile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional home profile associated with host '${name}'.";
        };

        aspect = mkOption {
          type = types.nullOr types.str;
          default = name;
          description = "Primary aspect name for host '${name}' when using flake-aspects/den.";
        };

        stateVersion = mkOption {
          type = types.str;
          default = "24.11";
          description = "System stateVersion applied to host '${name}'.";
        };

        extraModules = mkOption {
          type = types.listOf types.raw;
          default = [ ];
          description = "Additional ad-hoc modules appended after aspect modules for host '${name}'.";
        };

        den = mkOption {
          type = types.submodule {
            options = {
              enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable exporting this host as a den osConfiguration.";
              };

              description = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Optional description for the generated den host.";
              };

              extraConfig = mkOption {
                type = types.attrsOf types.anything;
                default = { };
                description = "Additional configuration merged into the generated den host.";
              };
            };
          };
          default = { };
          description = "den integration settings for this host.";
        };
      };
    }
  );
in
{
  options.autix.os.hosts = mkOption {
    type = types.attrsOf hostType;
    default = { };
    description = "Declarative host definitions built from aspect targets.";
  };
}
