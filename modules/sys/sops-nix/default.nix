{ inputs, lib, ... }:
let
  inherit (lib)
    attrValues
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
  defaultSecretPath = name: "/run/secrets/${name}";
  defaultSecretGroup = name: sanitizeSecretName name;

  sharedSecretType =
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
            default = "root";
            description = "Filesystem owner for '${name}'.";
          };

          group = mkOption {
            type = types.nullOr types.str;
            default = defaultSecretGroup name;
            defaultText = literalExample ''"${defaultSecretGroup name}"'';
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

  sharedSecretsOption = mkOption {
    type = types.attrsOf sharedSecretType;
    default = { };
    description = "Reusable shared secret provisioning between NixOS and Home Manager.";
  };

  sharedOptionsModule = {
    options.autix.sops-nix.sharedSecrets = sharedSecretsOption;
  };

  hmModule =
    { pkgs, ... }:
    {
      imports = [
        sharedOptionsModule
        inputs.sops-nix.homeManagerModules.sops
      ];

      config.home.packages =
        with pkgs;
        mkAfter [
          sops
          inputs.sops-nix.packages.${pkgs.system}.default
        ];
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
                  owner = secretCfg.owner;
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
        sharedOptionsModule
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
