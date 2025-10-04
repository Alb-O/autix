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
          extraPortals = if portalNeedsGnome then [ pkgs.xdg-desktop-portal-gnome ] else [ ];
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

      programs.foot.enable = true;
      systemd.user.services."niri-flake-polkit".enable = lib.mkForce false;
    };

  flake-file = {
    inputs = {
      niri-flake.url = "github:sodiboo/niri-flake";
      niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
in
{
  autix.aspects.niri = {
    description = "Niri Wayland compositor and related tooling.";
    overlays.niri = inputs.niri-flake.overlays.niri;
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };

  flake = {
    nixosModules.niri = nixosModule;
    homeModules.niri = hmModule;
  };

  inherit flake-file;
}
