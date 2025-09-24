{ inputs, lib, ... }:
let
  niriConfig = builtins.readFile ./config.kdl;

  hmModule =
    { config, pkgs, ... }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
      niriPackage = inputs.niri-flake.packages.${pkgs.system}.niri-stable;
    in
    {
      imports = [ inputs.niri-flake.homeModules.niri ];
      config = lib.mkIf isGraphical {
        programs.niri = {
          enable = true;
          package = niriPackage;
          config = niriConfig;
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
