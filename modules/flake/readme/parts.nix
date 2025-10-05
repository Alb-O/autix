{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    concatStringsSep
    mapAttrsToList
    ;
  inherit (config.autix) aspects;

  aspectsTable =
    let
      rows = mapAttrsToList (
        name: aspect:
        let
          hasNixos = (aspect.nixos.modules or [ ]) != [ ] || (aspect.nixos.targets or [ ]) != [ ];
          hasHome = (aspect.home.modules or [ ]) != [ ] || (aspect.home.targets or [ ]) != [ ];
          scopes =
            if hasNixos && hasHome then
              "NixOS, Home"
            else if hasNixos then
              "NixOS"
            else if hasHome then
              "Home"
            else
              "None";
        in
        "| `${name}` | ${aspect.description or "—"} | ${scopes} |"
      ) aspects;
    in
    concatStringsSep "\n" rows;
in
{
  options.text.readme.parts = mkOption {
    type = types.attrsOf types.str;
    default = { };
    description = "Sections of the README, generated from Nix configuration.";
  };

  config.text.readme.parts = {
    aspects = ''
      ## Aspects

      Autix uses a modular **aspect system** for configuration. Each aspect represents a logical
      unit of functionality that can target specific hosts or profiles.

      ### Aspect Details

      | Aspect | Description | Scopes |
      |--------|-------------|--------|
      ${aspectsTable}

      Aspects are defined in `modules/` directories and automatically aggregated by the build system.
      Each aspect can contribute:
      - Modules for NixOS or Home Manager
      - Overlays for package customization
      - Unfree package permissions
      - Binary cache substituters and keys

      See [`modules/aspect/options.nix`](modules/aspect/options.nix) for the full aspect schema.
    '';

    profiles = ''
      ## Home Manager Profiles

      Profiles define Home Manager configurations. Each profile specifies:
      - User account
      - System architecture
      - Additional custom modules

      Available profiles:
      ${concatStringsSep "\n" (
        mapAttrsToList (name: profile: "- **${name}**: User `${profile.user}`") config.autix.home.profiles
      )}

      Build a profile:
      ```console
      $ nix build .#homeConfigurations.<profile>.activationPackage
      ```

      See [`modules/hm/+profiles/options.nix`](modules/hm/+profiles/options.nix) for profile options.
    '';

    hosts = ''
      ## NixOS Hosts

      Host configurations for NixOS systems:
      ${concatStringsSep "\n" (
        mapAttrsToList (
          name: host:
          "- **${name}**: ${host.system}${
            if host.profile != null then ", profile: `${host.profile}`" else ""
          }"
        ) config.autix.os.hosts
      )}

      Build a host configuration:
      ```console
      $ nixos-rebuild switch --flake .#<hostname>
      ```

      See [`modules/sys/hosts/options.nix`](modules/sys/hosts/options.nix) for host options.
    '';

    project-structure = ''
      ## Project Structure

      ```
      modules/
      ${config.text.readme.tree}
      ```

      Files/directories prefixed with `_` or `.` are ignored by auto-import.
      All `.nix` files in `modules/` are automatically imported as flake-parts modules.
    '';
  };

  config.flake.meta = {
    inherit (config.text.readme) parts;
  };
}
