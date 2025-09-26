{ pkgs, ... }:
{
  name = "smart-paste";
  package = pkgs.yaziPlugins.smart-paste;
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "p";
        run = "plugin smart-paste";
        desc = "Paste into the hovered directory or CWD";
      }
    ];
  };
}
