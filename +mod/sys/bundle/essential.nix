{ lib, ... }:
let
  packages =
    pkgs: with pkgs; [
      alacritty
      curl
      fastfetch
      firefox
      git
      jq
      just
      nano
      vim
      nmap
    ];

  hmModule =
    { pkgs, ... }:
    {
      home.packages = lib.mkDefault (packages pkgs);
    };

  nixosModule =
    { pkgs, ... }:
    {
      environment.systemPackages = packages pkgs;
    };

  moduleArgs = {
    autixPackages = {
      core = {
        essential = packages;
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.essential-bundle = pkgs.symlinkJoin {
        name = "autix-bundle-essential";
        paths = packages pkgs;
      };
    };
in
{
  autix.aspects.essential = {
    description = "Baseline essential packages for all profiles and hosts.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };

  flake.nixosModules.essential = nixosModule;

  inherit perSystem;

  _module.args = moduleArgs;
}
