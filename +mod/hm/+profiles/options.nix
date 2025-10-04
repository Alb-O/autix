{ lib, ... }:
let
  inherit (lib) mkOption types;

  profileType = types.submodule (
    { name, ... }:
    {
      options = {
        user = mkOption {
          type = types.str;
          description = "Primary user account for profile '${name}'.";
        };

        system = mkOption {
          type = types.str;
          default = "x86_64-linux";
          description = "Target system identifier for profile '${name}'.";
        };

        graphical = mkOption {
          type = types.bool;
          default = false;
          description = "Whether profile '${name}' assumes a graphical session.";
        };

        stateVersion = mkOption {
          type = types.str;
          default = "24.05";
          description = "Home Manager stateVersion for profile '${name}'.";
        };

        homeDirectory = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional override for the user's home directory.";
        };

        extraModules = mkOption {
          type = types.listOf types.raw;
          default = [ ];
          description = "Additional modules appended after aspect modules for profile '${name}'.";
        };

        extraUnfreePackages = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional unfree package names permitted for profile '${name}'.";
        };
      };
    }
  );
in
{
  options.autix.home.profiles = mkOption {
    type = types.attrsOf profileType;
    default = { };
    description = "Declarative Home Manager profiles keyed by name.";
  };
}
