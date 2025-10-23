{ lib, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    let
      opencodeConf = import ./_config { inherit lib pkgs config; };
      jsonFormat = pkgs.formats.json { };
      cfg = config.autix.opencode;

      settingsWithSchema =
        {
          "$schema" = "https://opencode.ai/config.json";
        }
        // cfg.settings;

  placeholderFor = config.autix.secretsHelpers.placeholderFor;

      applySecretBinding =
        acc: binding:
        let
          value = placeholderFor binding.secret;
        in
        lib.recursiveUpdate acc (lib.setAttrByPath binding.path value);

      renderedSettings = lib.foldl' applySecretBinding settingsWithSchema cfg.secretBindings;
    in
    {
      options.autix.opencode = {
        settings = lib.mkOption {
          type = jsonFormat.type;
          default = { };
          description = "Aggregated OpenCode settings contributed by autix modules.";
        };

        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages installed alongside OpenCode tooling.";
        };

        secretBindings = lib.mkOption {
          type =
            lib.types.listOf (
              lib.types.submodule (
                { ... }:
                {
                  options = {
                    path = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      description = "Location within the OpenCode config to populate with the secret value.";
                    };

                    secret = lib.mkOption {
                      type = lib.types.str;
                      description = "Name of the SOPS secret whose value will be injected.";
                    };

                    default = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "Fallback value used when the secret is unavailable (pure evaluations).";
                    };
                  };
                }
              )
            );
          default = [ ];
          description = "Secret placeholders that should be rendered into the OpenCode configuration.";
        };
      };

      config = {
        autix.opencode.settings = opencodeConf.settings;
        autix.opencode.packages = opencodeConf.packages;

        programs.opencode.enable = true;
        programs.opencode.settings = lib.mkForce { };

        home.packages = lib.unique cfg.packages;

        sops.templates.autix-opencode-config =
          let
            renderedConfig =
              jsonFormat.generate "autix-opencode-config.json" renderedSettings;
          in
          {
            file = renderedConfig;
            path = "${config.xdg.configHome}/opencode/config.json";
            mode = "0600";
          };
      };
    };
in
{
  autix.aspects.opencode = {
    description = "OpenCode configuration.";
    home = {
      master = true;
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
