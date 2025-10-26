{ lib
, config
, ...
}:
let
  inherit (lib)
    attrsets
    filterAttrs
    foldl'
    mapAttrsToList
    optionalAttrs
    recursiveUpdate
    ;

  profiles = config.autix.home.profiles;
  denEnabledProfiles = filterAttrs (_: profile: profile.den.enable) profiles;

  homeToAttrSet =
    profileName: profile:
    let
      aspectName =
        if profile.aspect != null then profile.aspect else profile.user;
      baseConfig =
        {
          aspect = aspectName;
          userName = profile.user;
        }
        // optionalAttrs (profile.den.description != null) {
          description = profile.den.description;
        }
        // profile.den.extraConfig;
    in
    attrsets.setAttrByPath [ profile.system profileName ] baseConfig;

  denHomesAttrSets = mapAttrsToList homeToAttrSet denEnabledProfiles;
  denHomes = foldl' recursiveUpdate { } denHomesAttrSets;
in
{
  den.homes = denHomes;
}
