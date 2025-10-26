{ inputs
, lib
, withSystem
, ...
}:
let
  system = "x86_64-linux";
  homeName = "albert";
  allowUnfreeModule = {
    nixpkgs.config.allowUnfree = true;
  };
in
{
  flake.homeConfigurations = lib.mkForce {
    ${homeName} =
      withSystem system (
        { pkgs, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            inputs.self.modules.homeManager.${homeName}
            allowUnfreeModule
          ];
        }
      );
  };
}
