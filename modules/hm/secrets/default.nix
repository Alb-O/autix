{ lib, ... }:
let
  computeSecretArtifacts = cfg:
    let
      secretBindings =
        lib.flatten (
          lib.mapAttrsToList
            (
              secretName: secret:
                (lib.mapAttrsToList
                  (
                    valueName: value:
                      if lib.isAttrs value && value ? secret then
                        [
                          {
                            path = [ "secrets" secretName "values" valueName ];
                            secret = value.secret;
                            default = value.placeholder;
                          }
                        ]
                      else
                        [ ]
                  )
                  secret.values
                ) ++ secret.bindings
            )
            cfg.secrets
        );

      secretNames = lib.unique (map (binding: binding.secret) secretBindings);

      injectSecrets = config:
        lib.foldl (acc: binding: lib.setAttrByPath binding.path binding.default acc) config secretBindings;
    in
    {
      inherit secretBindings secretNames injectSecrets;
    };

  placeholderFor = secret: "<SOPS:" + builtins.hashString "sha256" secret + ":PLACEHOLDER>";

  hmModule =
    { config, ... }:
    let
      cfg = config.autix.secrets;
      artifacts = computeSecretArtifacts cfg;
    in
    {
      config = {
        sops.secrets = lib.genAttrs artifacts.secretNames (_: { });
      };
    };

  helpersModule = { ... }: {
    config.autix.secretsHelpers = {
      inherit computeSecretArtifacts placeholderFor;
    };
  };

  optionsModule = import ./options.nix { inherit lib; };
in
{
  autix.aspects.secrets = {
    description = "Generic secret injection and management utilities.";
    home = {
      targets = [ "*" ];
      modules = [
        optionsModule
        hmModule
        helpersModule
      ];
    };
  };
}
