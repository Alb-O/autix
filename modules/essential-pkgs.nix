_:
let
  essentialPackages =
    pkgs: with pkgs; [
      vim
      nano
      git
      curl
      just
      jq
      fastfetch
      firefox
      alacritty
    ];

  hmModule =
    { pkgs, lib, ... }:
    {
      home.packages = lib.mkDefault (essentialPackages pkgs);
    };

  autix = {
    home.modules."essential-pkgs" = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;

    nixosModules."essential-pkgs" =
      { pkgs, ... }:
      {
        environment.systemPackages = essentialPackages pkgs;
      };
  };

  moduleArgs = {
    autixPackages = {
      essential = essentialPackages;
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.essential-pkgs-bundle = pkgs.symlinkJoin {
        name = "essential-pkgs";
        paths = essentialPackages pkgs;
      };
    };
in
{
  inherit autix flake perSystem;
  _module.args = moduleArgs;
}
