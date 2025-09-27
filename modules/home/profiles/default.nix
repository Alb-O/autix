{
  inputs,
  lib,
  config,
  ...
}:
let
  hmAspects = lib.attrByPath [ "autix" "home" "modules" ] { } config;

  requireAspect =
    name:
    if lib.hasAttr name hmAspects then
      hmAspects.${name}
    else
      throw "Home-manager aspect '${name}' is not defined";

  optionsModule = lib.attrByPath [ "flake" "modules" "homeManager" "profileOptions" ] null config;

  commonAspectNames = [
    "fonts"
    "kitty"
    "essential-pkgs"
    "networking"
    "ssh"
    "workspace"
    "xdg"
    "fzf"
    "zoxide"
    "opencode"
    "codex"
    "mpv"
    "yazi"
    "lazygit"
  ];

  selectAspects = names: map requireAspect names;

  commonModules =
    (lib.optional (optionsModule != null) optionsModule) ++ selectAspects commonAspectNames;

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
