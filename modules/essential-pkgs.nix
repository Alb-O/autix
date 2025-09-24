_:
let
  essentialPackages =
    pkgs: with pkgs; [
      # Text editors
      vim
      nano

      # Git
      git

      # Network tools
      curl
      wget

      # Development tools
      just
      jq

      # The 'just accidently booted into niri with no config' start pack
      firefox
      alacritty
    ];

  hmModule =
    { pkgs, lib, ... }:
    {
      home.packages = lib.mkDefault (essentialPackages pkgs);
    };
in
{
  config = {
    flake.modules.nixos."essential-pkgs" =
      { pkgs, ... }:
      {
        environment.systemPackages = essentialPackages pkgs;
      };

    flake.modules.homeManager."essential-pkgs" = hmModule;
    autix.home.modules."essential-pkgs" = hmModule;
    _module.args.autixPackages = {
      essential = essentialPackages;
    };
    perSystem =
      { pkgs, ... }:
      {
        packages.essential-pkgs-bundle = pkgs.symlinkJoin {
          name = "essential-pkgs";
          paths = essentialPackages pkgs;
        };
      };
  };
}
