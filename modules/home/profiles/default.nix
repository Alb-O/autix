{
  inputs,
  lib,
  config,
  ...
}:
let
  hmAspects = lib.attrByPath [ "flake" "modules" "homeManager" ] { } config;

  requireAspect =
    name:
    lib.assertMsg (lib.hasAttr name hmAspects) "Home-manager aspect '${name}' is not defined"
      hmAspects.${name};

  commonAspectNames = [
    "profileOptions"
    "fonts"
    "essential-pkgs"
    "networking"
    "ssh"
    "workspace"
    "tooling-cli"
    "tooling-dev"
    "tooling-graphical"
    "xdg"
    "fzf"
    "clipboard"
    "notifications"
    "polkit"
    "opencode"
    "sillytavern"
  ];

  selectAspects = names: map requireAspect names;

  commonModules = selectAspects commonAspectNames;

  modulesForProfile =
    profileName: profile:
    let
      aspectModules = selectAspects profile.modules;
      userModule = requireAspect profile.user;
      profileSettings = _: {
        autix.home.profile = {
          name = profileName;
          inherit (profile) graphical;
          inherit (profile) system;
        };
      };
    in
    commonModules
    ++ aspectModules
    ++ [
      userModule
      profileSettings
    ];

  buildProfile =
    profileName: profile:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${profile.system};
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = modulesForProfile profileName profile;
    };

  inherit (config.autix.home.profile) profiles;
in
{
  flake.homeConfigurations = lib.mapAttrs buildProfile profiles;
}
