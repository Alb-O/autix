{ lib, ... }:
let
  inherit (lib) mkOption types;

  hostType = types.submodule (
    { name, ... }:
    {
      options = {
        system = mkOption {
          type = types.str;
          description = "System identifier used to build the '${name}' host.";
        };

        profile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Home profile to activate for this host.";
        };

        layers = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Named OS module layers to include.";
        };

        modules = mkOption {
          type = types.listOf types.raw;
          default = [ ];
          description = "Additional nixos modules to include after the selected layers.";
        };
      };
    }
  );
in
{
  options.autix.os = {
    layers = mkOption {
      type = types.attrsOf (types.listOf types.raw);
      default = { };
      description = "Reusable sets of nixos modules referenced by host definitions.";
    };

    hosts = mkOption {
      type = types.attrsOf hostType;
      default = { };
      description = "Declarative host definitions built into nixosConfigurations.";
    };
  };
}
