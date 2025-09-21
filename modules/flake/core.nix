{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file = {
    description = "The cure to my autixm";
    nixConfig = {
      warn-dirty = false;
    };
    inputs = {
      flake-file.url = "github:vic/flake-file";
    };
  };
}
