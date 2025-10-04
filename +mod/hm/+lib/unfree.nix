_:
let
  helper =
    {
      inputs ? inputs,
      lib ? lib,
      config ? config,
    }:
    let
      inherit (lib)
        attrByPath
        attrValues
        concatMap
        optionalAttrs
        unique
        ;

      moduleUnfreePackages = attrByPath [ "autix" "home" "modules" "unfreePackages" ] { } config;

      moduleNamesFor =
        profile:
        {
          baseModuleNames,
        }:
        unique (baseModuleNames ++ profile.modules ++ [ profile.user ]);

      permittedFor = names: unique (concatMap (name: attrByPath [ name ] [ ] moduleUnfreePackages) names);

      pkgsFor =
        {
          system,
          permittedUnfreePackages ? [ ],
        }:
        let
          overlays = attrByPath [ "flake" "overlays" ] { } config;
          overlayList = attrValues overlays;
        in
        import inputs.nixpkgs (
          {
            inherit system;
            overlays = overlayList;
          }
          // optionalAttrs (permittedUnfreePackages != [ ]) {
            config = {
              allowUnfree = true;
              inherit permittedUnfreePackages;
              allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) permittedUnfreePackages;
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
