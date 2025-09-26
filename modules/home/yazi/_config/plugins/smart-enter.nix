{ pkgs, ... }:
{
  name = "smart-enter";
  package = pkgs.yaziPlugins.smart-enter;
  setupOptions = {
    open_multi = false;
  };
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
    ];
  };
}
