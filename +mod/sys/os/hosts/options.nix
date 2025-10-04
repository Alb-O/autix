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
