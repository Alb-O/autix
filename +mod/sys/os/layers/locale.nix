{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layerTree.base.children.locale = {
    description = "Locale, time and language preferences.";
    modules = with modules; [
      i18n
    ];
  };
}
