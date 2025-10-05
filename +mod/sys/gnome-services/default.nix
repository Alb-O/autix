_:
let
  nixosModule =
    { pkgs, ... }:
    {
      security.pam.services = {
        login.enableGnomeKeyring = true;
      };
      environment.systemPackages = with pkgs; [
        gnome-keyring
        libsecret
      ];
      programs.dconf.enable = true;
      services = {
        gnome.gnome-keyring.enable = true;
        udev.packages = [ pkgs.gnome-settings-daemon ];
      };
    };
in
{
  autix.aspects."gnome-services" = {
    description = "GNOME keyring and supporting services.";
    nixos = {
      targets = [ "desktop" ];
      modules = [ nixosModule ];
    };
  };
}
