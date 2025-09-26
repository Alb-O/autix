{ pkgs, ... }:
{
  name = "git";
  package = pkgs.yaziPlugins.git;
  settings = {
    plugin.prepend_fetchers = [
      {
        id = "git";
        name = "*";
        run = "git";
      }
      {
        id = "git";
        name = "*/";
        run = "git";
      }
    ];
  };
  extraPackages = [ pkgs.git ];
}
