{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layerTree.base = {
    description = "Essential system configuration shared by every host.";
    modules = with modules; [
      nix-settings
      shell-init
      essential-pkgs
      ssh
      fonts
    ];
  };
}
