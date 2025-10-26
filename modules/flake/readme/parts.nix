{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    concatStringsSep
    mapAttrsToList
    ;

  aspectsTable =
    let
      describeScopes =
        aspect:
        let
          classes = mapAttrsToList (class: _module: class) (
            removeAttrs aspect [
              "description"
              "includes"
              "provides"
              "__functor"
            ]
          );
        in
        if classes == [ ] then "—" else concatStringsSep ", " classes;
    in
    concatStringsSep "\n" (
      mapAttrsToList
        (
          name: aspect: "| `${name}` | ${aspect.description or "—"} | ${describeScopes aspect} |"
        )
        config.flake.aspects
    );
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

      Autix uses `flake.aspects` for all dendritic composition. Each aspect represents a logical
      unit of functionality that can target specific hosts or users.

      ### Aspect Details

      | Aspect | Description | Scopes |
      |--------|-------------|--------|
      ${aspectsTable}

      Aspects are defined in `modules/aspects/**`. Each aspect can contribute modules for any
      dendritic class (`nixos`, `homeManager`, etc.) and declare dependencies through `includes`.
    '';

    profiles = ''
      ## Hosts & Homes via den

      Host and user bindings are declared with [`den`](https://github.com/vic/den).
      Each host entry references the aspect tree that should be composed for the
      operating system and its users.

      Active hosts:
      ${concatStringsSep "\n" (
        mapAttrsToList (
          system: hosts:
          concatStringsSep "\n" (
            mapAttrsToList (name: host: "- **${name}** (${system}) — aspect `${host.aspect}`") hosts
          )
        ) config.den.hosts
      )}

      Build a host configuration:
      ```console
      $ nixos-rebuild switch --flake .#<hostname>
      ```

      Standalone homes can be registered in `den.homes` when needed.
    '';

    hosts = ''
      ## Aspect Topology

      The dendritic graph is orchestrated with `flake.aspects`. Host aspects stitch
      together system modules, while user aspects (such as `albert`) pull in
      Home Manager features.

      See [`modules/aspects/hosts.nix`](modules/aspects/hosts.nix) and
      [`modules/aspects/users/albert.nix`](modules/aspects/users/albert.nix) for the
      entry points used by `den`.
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
