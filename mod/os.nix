{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

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
    "git"
    "workspace"
    "xdg"
    "fzf"
    "zoxide"
    "opencode"
    "codex"
    "mpv"
    "yazi"
    "lazygit"
    "nh"
    "zk"
    "kakoune"
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
          inherit (profile) graphical system;
        };
      };
    in
    commonModules
    ++ aspectModules
    ++ [
      userModule
      profileSettings
    ];

  profileDefs = lib.attrByPath [ "autix" "home" "profile" "profiles" ] { } config;

  hostProfiles = {
    desktop = "albert-desktop";
    wsl = "albert-wsl";
  };

  homeManagerModulesFor =
    { system, host }:
    let
      profileName = lib.attrByPath [ host ] null hostProfiles;
    in
    if profileName == null then
      [ ]
    else if !(lib.hasAttr profileName profileDefs) then
      throw "Home profile '${profileName}' is not defined for host '${host}'"
    else
      let
        profile = profileDefs.${profileName};
        userName = profile.user;
        hmModules = modulesForProfile profileName profile;
      in
      [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${userName}.imports = hmModules;
          };
          environment.systemPackages = lib.mkAfter [
            inputs.home-manager.packages.${system}.home-manager
          ];
        }
      ];

  desktopLinux =
    { system, name }:
    let
      hmModules = homeManagerModulesFor {
        inherit system;
        host = name;
      };
    in
    nixosSystem {
      inherit system;
      modules =
        with inputs.self.nixosModules;
        [
          i18n
          niri
          nix-settings
          shell-init
          essential-pkgs
          dm
          tty
          wayland
          ssh
          gnome-services
          fonts
          keyboard
          albert

          inputs.self.nixosModules.${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
            system.stateVersion = "24.11";
            security.sudo.wheelNeedsPassword = false;
            _module.args.modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
          }
        ]
        ++ hmModules;
    };

  wslLinux =
    { system, name }:
    let
      hmModules = homeManagerModulesFor {
        inherit system;
        host = name;
      };
    in
    nixosSystem {
      inherit system;
      modules =
        with inputs.self.nixosModules;
        [
          i18n
          nix-settings
          shell-init
          essential-pkgs
          ssh
          fonts
          albert

          inputs.self.nixosModules.${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
            system.stateVersion = "24.11";
            security.sudo.wheelNeedsPassword = false;
            _module.args.modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
          }
        ]
        ++ hmModules;
    };
in
{
  flake.nixosConfigurations = {
    desktop = desktopLinux {
      system = "x86_64-linux";
      name = "desktop";
    };
    wsl = wslLinux {
      system = "x86_64-linux";
      name = "wsl";
    };
  };
}
