{ lib
, config
, ...
}:
let
  inherit (lib)
    attrByPath
    attrsets
    filterAttrs
    foldl'
    mapAttrsToList
    optionalAttrs
    recursiveUpdate
    ;

  hosts = config.autix.os.hosts;
  profiles = config.autix.home.profiles;

  denEnabledHosts = filterAttrs (_: host: host.den.enable) hosts;

  profileFor =
    profileName: attrByPath [ profileName ] null profiles;

  deriveUsers =
    host:
    if host.profile == null then
      { }
    else
      let
        profile = profileFor host.profile;
      in
      if profile == null || !(profile.den.enable or false) then
        { }
      else
        let
          aspectName =
            if profile.aspect != null then profile.aspect else profile.user;
        in
        {
          ${profile.user} = {
            userName = profile.user;
            aspect = aspectName;
          };
        };

  hostToAttrSet =
    hostName: host:
    let
      aspectName =
        if host.aspect != null then host.aspect else hostName;
      users = deriveUsers host;
      baseConfig =
        {
          inherit hostName;
          system = host.system;
          aspect = aspectName;
          users = users;
        }
        // optionalAttrs (host.den.description != null) {
          description = host.den.description;
        }
        // host.den.extraConfig;
    in
    attrsets.setAttrByPath [ host.system hostName ] baseConfig;

  denHostsAttrSets = mapAttrsToList hostToAttrSet denEnabledHosts;
  denHosts = foldl' recursiveUpdate { } denHostsAttrSets;
in
{
  den.hosts = denHosts;
}
