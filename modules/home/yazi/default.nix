_:
let
  hmModule =
    { pkgs, lib, ... }:
    let
      yaziConf = import ./_config { inherit lib pkgs; };
    in
    {
      programs.yazi = {
        enable = true;
        inherit (yaziConf)
          initLua
          plugins
          extraPackages
          settings
          keymap
          ;
      };
    };
in
{
  autix.home.modules.yazi = hmModule;
}
