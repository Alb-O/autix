{ inputs, lib, ... }:
let
  niriConfig = builtins.readFile ./config.kdl;

  hmModule =
    { config, pkgs, ... }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
      niriPackage = inputs.niri-flake.packages.${pkgs.system}.niri-stable;
      portalNeedsGnome =
        !niriPackage.cargoBuildNoDefaultFeatures
        || builtins.elem "xdp-gnome-screencast" niriPackage.cargoBuildFeatures;
    in
    {
      config = lib.mkIf isGraphical {
        home.packages = lib.mkAfter [ niriPackage ];

        xdg.configFile."niri/config.kdl" = {
          enable = true;
          source = pkgs.writeText "niri-config.kdl" niriConfig;
        };

        services.gnome-keyring.enable = true;

        xdg.portal = {
          enable = true;
          extraPortals =
            if portalNeedsGnome then [ pkgs.xdg-desktop-portal-gnome ] else [ ];
          configPackages = [ niriPackage ];
        };
      };
    };

  nixosModule =
    { lib, pkgs, ... }:
    let
      niriPackage = inputs.niri-flake.packages.${pkgs.system}.niri-stable;
    in
    {
      imports = [ inputs.niri-flake.nixosModules.niri ];
      programs.niri = {
        enable = true;
        package = niriPackage;
      };

      # Fallback terminal emulator
      programs.foot = {
        enable = true;
      };

      systemd.user.services."niri-flake-polkit".enable = lib.mkForce false;
    };
in
{
  flake-file = {
    inputs = {
      niri-flake.url = "github:sodiboo/niri-flake";
      niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.overlays.niri = inputs.niri-flake.overlays.niri;
  flake.nixosModules.niri = nixosModule;
  flake.modules.nixos.niri = nixosModule;
  flake.homeModules.niri = hmModule;
  flake.modules.homeManager.niri = hmModule;
  autix.home.modules.niri = hmModule;
}
