{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layerTree.base.children.locale.children.wsl = {
    description = "Windows Subsystem for Linux specific adjustments.";
    modules = with modules; [
      wsl
    ];
  };
}
