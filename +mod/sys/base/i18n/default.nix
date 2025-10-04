_:
let
  nixosModule = {
    i18n.defaultLocale = "en_US.UTF-8";
  };
in
{
  autix.aspects.i18n = {
    description = "Default locale configuration.";
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
