{
  inputs,
  lib,
  config,
  ...
}:
let
  helpers = config.autix.home.profileSupport;

  buildProfile =
    profileName: profile:
    helpers.mkHomeConfiguration profileName profile;

  inherit (config.autix.home.profile) profiles;
in
{
  flake.homeConfigurations = lib.mapAttrs buildProfile profiles;
}
