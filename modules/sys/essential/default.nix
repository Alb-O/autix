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
      nmap
      lsof
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
in
{
  flake.aspects.essential = {
    description = "Baseline essential packages for all profiles and hosts.";
    homeManager = hmModule;
    nixos = nixosModule;
  };
}
