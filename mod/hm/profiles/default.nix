{ config, lib, ... }:
let
  helpers = config.autix.home.profile.lib;

  buildProfile =
    profileName: profile:
    helpers.mkHomeConfiguration profileName profile;

  inherit (config.autix.home.profile) profiles;
in
{
  flake.homeConfigurations = lib.mapAttrs buildProfile profiles;
}
