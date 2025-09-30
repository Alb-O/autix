{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layerTree.base.children.user = {
    description = "User account provisioning shared across hosts.";
    modules = with modules; [
      albert
    ];
  };
}
