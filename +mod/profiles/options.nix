{ lib, ... }:
let
  inherit (lib) mkOption types;

  profileType = types.submodule {
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

      graphical = mkOption {
        type = types.bool;
        default = false;
        description = "Whether profile targets a graphical session.";
      };

      extraModules = mkOption {
        type = types.listOf types.raw;
        default = [ ];
        description = "Additional modules appended after aspect modules.";
      };
    };
  };
in
{
  options.autix.home.profiles = mkOption {
    type = types.attrsOf profileType;
    default = { };
    description = "Declarative Home Manager profiles keyed by name.";
  };
}
