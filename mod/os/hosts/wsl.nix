{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.hosts.wsl = {
    system = "x86_64-linux";
    profile = "albert-wsl";
    paths = [
      (layerPaths: layerPaths.base.locale.wsl)
      (layerPaths: layerPaths.base.user)
    ];
    extraModules = [ modules.wsl ];
  };
}
