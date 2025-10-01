{ inputs, lib, config, ... }:
let
  helper =
    { inputs ? inputs, lib ? lib, config ? config }:
    let
      inherit (lib)
        attrByPath
        concatMap
        optionalAttrs
        unique;

      moduleUnfreePackages =
        attrByPath [ "autix" "home" "modules" "unfreePackages" ] { } config;

      moduleNamesFor =
        profile:
        {
          baseModuleNames,
        }:
        unique (baseModuleNames ++ profile.modules ++ [ profile.user ]);

      permittedFor = names:
        unique (
          concatMap
            (name: attrByPath [ name ] [ ] moduleUnfreePackages)
            names
        );

      pkgsFor =
        {
          system,
          permittedUnfreePackages ? [ ],
        }:
        import inputs.nixpkgs (
          {
            inherit system;
          }
          // optionalAttrs (permittedUnfreePackages != [ ]) {
            config = {
              allowUnfree = true;
              permittedUnfreePackages = permittedUnfreePackages;
              allowUnfreePredicate =
                pkg:
                builtins.elem (inputs.nixpkgs.lib.getName pkg) permittedUnfreePackages;
            };
          }
        );
    in
    {
      inherit moduleNamesFor permittedFor pkgsFor;
    };
in
{
  _module.args.autixUnfree = helper;
  flake.lib.unfree = helper;
}
