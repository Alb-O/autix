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
  config = {
    flake.modules.homeManager.yazi = hmModule;
    autix.home.modules.yazi = hmModule;
  };
}
