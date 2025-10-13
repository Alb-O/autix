{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  moduleListType = types.listOf types.raw;
  targetListType = types.listOf types.str;

  targetModulesType = types.submodule (
    { name, ... }:
    {
      options = {
        modules = mkOption {
          type = moduleListType;
          default = [ ];
          description = "Modules applied when aspect targets '${name}'.";
        };

        unfreePackages = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Unfree packages permitted when targeting '${name}'.";
        };

        substituters = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Binary cache substituters when targeting '${name}'.";
        };

        trustedPublicKeys = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Trusted public keys for substituters when targeting '${name}'.";
        };
      };
    }
  );

  scopeType = types.submodule (_: {
    options = {
      description = mkOption {
        type = types.str;
        default = "";
        description = "Human readable summary for this aspect scope.";
      };

      modules = mkOption {
        type = moduleListType;
        default = [ ];
        description = "Modules applied to every matching target for this scope.";
      };

      targets = mkOption {
        type = targetListType;
        default = [ ];
        description = "List of identifiers (or '*') that enable this scope's modules.";
      };

      master = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use the master branch of nixpkgs for this scope.";
      };

      perTarget = mkOption {
        type = types.attrsOf targetModulesType;
        default = { };
        description = "Additional modules keyed by specific target name.";
      };

      unfreePackages = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Unfree package names permitted when this scope is active.";
      };

      substituters = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Binary cache substituters for this scope.";
      };

      trustedPublicKeys = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Trusted public keys for substituters in this scope.";
      };
    };
  });

  aspectType = types.submodule (
    { name, ... }:
    {
      options = {
        description = mkOption {
          type = types.str;
          default = "";
          description = "Human readable summary for aspect '${name}'.";
        };

        overlays = mkOption {
          type = types.attrsOf types.raw;
          default = { };
          description = "Flake overlays contributed by aspect '${name}'.";
        };

        nixos = mkOption {
          type = scopeType;
          default = { };
          description = "NixOS scope configuration for aspect '${name}'.";
        };

        home = mkOption {
          type = scopeType;
          default = { };
          description = "Home Manager scope configuration for aspect '${name}'.";
        };
      };
    }
  );
in
{
  options.autix.aspects = mkOption {
    type = types.attrsOf aspectType;
    default = { };
    description = "Registry of declarative aspects for hosts and profiles.";
  };
}
