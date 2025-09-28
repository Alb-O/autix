_:
let
  hmModule =
    { lib, pkgs, ... }:
    {
      programs.kakoune = {
        enable = true;
        defaultEditor = true;
      };
      xdg.configFile = {
        "kak/kakrc".source = lib.mkForce ./kakrc;
        "kak/plugins" = {
          source = ./plugins;
          recursive = true;
        };
        "kak/colors" = {
          source = ./colors;
          recursive = true;
        };
        "kak/filetypes" = {
          source = ./filetypes;
          recursive = true;
        };
      };
      home.packages = lib.mkAfter (
        with pkgs;
        [
          kakoune-lsp
          kak-tree-sitter
          kamp
        ]
      );
    };

  autix = {
    home.modules.kakoune = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;
  };
in
{
  inherit autix flake;
}
