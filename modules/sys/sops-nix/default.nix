{ inputs, lib, ... }:
let
  inherit (lib)
    attrValues
    escapeShellArg
    foldl'
    literalExample
    mapAttrs
    mapAttrs'
    mkAfter
    mkIf
    mkOption
    optionalAttrs
    replaceStrings
    types;

  sanitizeSecretName = name: replaceStrings [ "/" " " ] [ "-" "-" ] name;
  defaultSystemSecretPath = name: "/run/secrets/${sanitizeSecretName name}";
  defaultSecretGroup = name: sanitizeSecretName name;

  mkSharedSecretType = defaults:
    let
      defaultSecretPath = defaults.defaultSecretPath;
      defaultOwner = defaults.defaultOwner;
      defaultGroup = defaults.defaultGroup or defaultSecretGroup;
    in
    types.submodule (
      { name, ... }:
      {
        options = {
          sopsKey = mkOption {
            type = types.str;
            default = name;
            defaultText = literalExample ''"${name}"'';
            description = "Key under `sops.secrets` for shared secret '${name}'.";
          };

          path = mkOption {
            type = types.str;
            default = defaultSecretPath name;
            defaultText = literalExample ''"${defaultSecretPath name}"'';
            description = "Filesystem path for the decrypted secret '${name}'.";
          };

          owner = mkOption {
            type = types.str;
            default = defaultOwner name;
            defaultText = literalExample ''"${defaultOwner name}"'';
            description = "Filesystem owner for '${name}'.";
          };

          group = mkOption {
            type = types.nullOr types.str;
            default = defaultGroup name;
            defaultText = literalExample ''"${defaultGroup name}"'';
            description = "Group granted read access to '${name}'. Set to `null` to disable group provisioning.";
          };

          mode = mkOption {
            type = types.str;
            default = "0440";
            description = "File mode for '${name}'. Defaults to group-readable when a group is provisioned.";
          };

          includeHomeManagerUsers = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to add Home Manager users to the provisioned group for '${name}'.";
          };

          extraGroupMembers = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Additional user names to grant access to '${name}'.";
          };

          enableNeededForUsers = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to set `neededForUsers = true` for '${name}'.";
          };

          extraConfig = mkOption {
            type = types.attrsOf types.raw;
            default = { };
            description = "Additional attributes merged into the `sops.secrets` entry for '${name}'.";
          };
        };
      }
    );

  sharedSecretsOption = defaults:
    mkOption {
      type = types.attrsOf (mkSharedSecretType defaults);
      default = { };
      description = "Reusable shared secret provisioning between NixOS and Home Manager.";
    };

  mkSharedOptionsModule = getDefaults:
    { config, ... }:
    let
      defaults = getDefaults config;
    in
    {
      options.autix.sops-nix.sharedSecrets = sharedSecretsOption defaults;
    };

  hmModule =
    { config, lib, pkgs, ... }:
    let
      getSecretDirectory = cfg:
        let
          stateHome = cfg.xdg.stateHome or "${cfg.home.homeDirectory}/.local/state";
        in
        "${stateHome}/autix/secrets";

      defaultHomeSecretPath = cfg: name: "${getSecretDirectory cfg}/${sanitizeSecretName name}";

      homeDefaults = cfg: {
        defaultSecretPath = defaultHomeSecretPath cfg;
        defaultOwner = _: cfg.home.username;
        defaultGroup = _: null;
      };

      secretDirectory = getSecretDirectory config;
      cfg = config.autix.sops-nix.sharedSecrets;
      hasSecrets = attrValues cfg != [ ];

      sopsSecretEntries =
        mapAttrs'
          (_: secretCfg:
            lib.nameValuePair secretCfg.sopsKey (
              {
                mode = secretCfg.mode;
                path = secretCfg.path;
              }
              // secretCfg.extraConfig
            )
          )
          cfg;
    in
    {
      imports = [
        (mkSharedOptionsModule homeDefaults)
        inputs.sops-nix.homeManagerModules.sops
      ];

      config = mkIf hasSecrets {
        home.packages =
          with pkgs;
          mkAfter [
            sops
            inputs.sops-nix.packages.${pkgs.system}.default
          ];

        home.activation.autix-sops-secret-directory =
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            install -m700 -d ${escapeShellArg secretDirectory}
          '';

        sops.secrets = sopsSecretEntries;
      };
    };

  nixosModule =
    { config, lib, ... }:
    let
      inherit (lib)
        attrNames
        mkMerge
        unique;

      hmUsers = attrNames (config.home-manager.users or { });
      cfg = config.autix.sops-nix.sharedSecrets;

      systemDefaults = _: {
        defaultSecretPath = defaultSystemSecretPath;
        defaultOwner = _: "root";
        defaultGroup = defaultSecretGroup;
      };

      hmMembers = cfg:
        if cfg.includeHomeManagerUsers then hmUsers else [ ];

      needsUserSessions = cfg: cfg.enableNeededForUsers;

      groupMembers =
        foldl'
          (acc: secretCfg:
            let
              members = unique (hmMembers secretCfg ++ secretCfg.extraGroupMembers);
              group = secretCfg.group;
            in
            if group == null || members == [ ] then acc else acc // {
              ${group} = unique ((acc.${group} or [ ]) ++ members);
            }
          )
          { }
          (attrValues cfg);

      sopsSecretEntries =
        mapAttrs'
          (_: secretCfg:
            lib.nameValuePair secretCfg.sopsKey (
              mkMerge [
                {
                  mode = secretCfg.mode;
                  path = secretCfg.path;
                }
                (optionalAttrs (secretCfg.group != null) { group = secretCfg.group; })
                (optionalAttrs (needsUserSessions secretCfg) {
                  neededForUsers = true;
                })
                secretCfg.extraConfig
              ]
            )
          )
          cfg;
    in
    {
      imports = [
        (mkSharedOptionsModule systemDefaults)
        inputs.sops-nix.nixosModules.sops
      ];

      config = mkIf (cfg != { }) {
        users.groups = mapAttrs (_: members: { members = mkAfter members; }) groupMembers;
        sops.secrets = sopsSecretEntries;
      };
    };
in
{
  flake-file = {
    inputs = {
      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.sops-nix = {
    description = "Atomic secret provisioning for NixOS based on sops.";
    overlays.sops-nix = inputs.sops-nix.overlays.default;
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
