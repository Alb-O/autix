{ inputs, ... }:
let
  modules = inputs.self.nixosModules;
in
{
  config.autix.os.layers = {
    base = with modules; [ nix-settings shell-init essential-pkgs ssh fonts ];
    locale = with modules; [ i18n keyboard ];
    graphical = with modules; [ niri dm tty wayland gnome-services desktop ];
    user = [ modules.albert ];
    wsl = [ modules.wsl ];
  };
}
