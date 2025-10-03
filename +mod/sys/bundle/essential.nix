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
  autix.home.modules.essential = hmModule;

  flake.nixosModules.essential = nixosModule;

  inherit perSystem;

  _module.args = moduleArgs;
}
