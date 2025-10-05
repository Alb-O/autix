{ inputs, lib, ... }:
let
  niriConfig = builtins.readFile ./config.kdl;

  hmModule =
    { pkgs, ... }:
    let
      niriPackage = inputs.niri-flake.packages.${pkgs.system}.niri-stable;
      portalNeedsGnome =
        !niriPackage.cargoBuildNoDefaultFeatures
        || builtins.elem "xdp-gnome-screencast" niriPackage.cargoBuildFeatures;
    in
    {
      home.packages = lib.mkAfter [ niriPackage ];
      xdg.configFile."niri/config.kdl" = {
        enable = true;
        source = pkgs.writeText "niri-config.kdl" niriConfig;
      };
      xdg.portal = {
        enable = true;
        extraPortals = if portalNeedsGnome then [ pkgs.xdg-desktop-portal-gnome ] else [ ];
        configPackages = [ niriPackage ];
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
in
{
  flake-file = {
    inputs = {
      niri-flake.url = "github:sodiboo/niri-flake";
      niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
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
}
