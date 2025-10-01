{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layerTree.base.children.locale.children.graphical = {
    description = "Graphical session stack for desktop environments.";
    modules = with modules; [
      niri
      dm
      tty
      wayland
      gnome-services
      keyboard
    ];
  };
}
