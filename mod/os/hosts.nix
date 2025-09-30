{ inputs, lib, config, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  helpers = config.autix.home.profileSupport;

  modules = inputs.self.nixosModules;

  moduleLayers =
    let
      inherit (modules)
        albert
        desktop
        dm
        essential-pkgs
        fonts
        gnome-services
        i18n
        keyboard
        nix-settings
        niri
        shell-init
        ssh
        tty
        wayland
        wsl;
    in
    {
      base = [ nix-settings shell-init essential-pkgs ssh fonts ];
      locale = [ i18n keyboard ];
      graphical = [ niri dm tty wayland gnome-services desktop ];
      user = [ albert ];
      wsl = [ wsl ];
    };

  hostDefinitions = {
    desktop = {
      system = "x86_64-linux";
      profile = "albert-desktop";
      layerNames = [ "base" "locale" "graphical" "user" ];
    };
    wsl = {
      system = "x86_64-linux";
      profile = "albert-wsl";
      layerNames = [ "base" "locale" "user" "wsl" ];
    };
  };

  modulesForLayers =
    layerNames:
    lib.concatMap (name: lib.getAttr name moduleLayers) layerNames;

  mkHost = name: { system, profile ? null, layerNames ? [ ], extraModules ? [ ] }:
    let
      hmModules = helpers.homeManagerModulesForProfile {
        profileName = profile;
        inherit system;
      };
      defaultsModule = {
        networking.hostName = name;
        nixpkgs.hostPlatform = system;
        system.stateVersion = "24.11";
        security.sudo.wheelNeedsPassword = false;
        _module.args.modulesPath = inputs.nixpkgs.outPath + "/nixos/modules";
      };
      hostModules = modulesForLayers layerNames ++ extraModules;
    in
    nixosSystem {
      inherit system;
      modules = hostModules ++ hmModules ++ [ defaultsModule ];
    };

in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost hostDefinitions;
}
