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
in
{
  flake.modules.nixos.essential-pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = essentialPackages pkgs;
    };

  flake.modules.homeManager.essential-pkgs =
    { pkgs, lib, ... }:
    {
      home.packages = lib.mkDefault (essentialPackages pkgs);
    };

  _module.args.autixPackages = {
    essential = essentialPackages;
  };

  # Expose a package bundle for this aspect
  perSystem =
    { pkgs, ... }:
    {
      packages.essential-pkgs-bundle = pkgs.symlinkJoin {
        name = "essential-pkgs";
        paths = essentialPackages pkgs;
      };
    };
}
