{ autixAspectHelpers, ... }:
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
        optionalAttrs
        ;

      overlays = attrValues (attrByPath [ "flake" "overlays" ] { } config);

      pkgsFor =
        {
          system,
          permittedUnfreePackages ? [ ],
        }:
        import inputs.nixpkgs (
          {
            inherit system overlays;
          }
          // optionalAttrs (permittedUnfreePackages != [ ]) {
            config = {
              allowUnfree = true;
              inherit permittedUnfreePackages;
              allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) permittedUnfreePackages;
            };
          }
        );

      permittedForProfile = profileName: autixAspectHelpers.unfreeForScope "home" profileName;
    in
    {
      inherit pkgsFor permittedForProfile;
    };
in
{
  _module.args.autixUnfree = helper;
  flake.lib.unfree = helper;
}
