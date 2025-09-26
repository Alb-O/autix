{ pkgs, ... }:
{
  name = "smart-filter";
  package = pkgs.yaziPlugins.smart-filter;
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "F";
        run = "plugin smart-filter";
        desc = "Smart filter";
      }
    ];
  };
}
