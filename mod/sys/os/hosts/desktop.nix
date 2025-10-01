{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.hosts.desktop = {
    system = "x86_64-linux";
    profile = "albert-desktop";
    paths = [
      (layerPaths: layerPaths.base.locale.graphical)
      (layerPaths: layerPaths.base.user)
    ];
    extraModules = [ modules.desktop ];
  };
}
