{ lib, inputs, ... }:
let
  hmModule =
    { pkgs, config, ... }:
    {
      config =
        let
          opencodeConf = import ./_config { inherit lib pkgs config; };
        in
        {
          programs.opencode = {
            enable = true;
            inherit (opencodeConf) settings;
          };
          home.packages = lib.mkAfter opencodeConf.packages;
        };
    };
in
{
  flake-file = {
    inputs = {
      nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    };
  };
  autix.aspects.opencode = {
    description = "OpenCode configuration.";
    overlays.opencode = (
      final: prev: {
        opencode = inputs.nixpkgs-master.legacyPackages.${final.system}.opencode;
      }
    );
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
