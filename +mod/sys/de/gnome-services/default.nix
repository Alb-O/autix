_:
let
  nixosModule =
    { pkgs, ... }:
    {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services = {
        login.enableGnomeKeyring = true;
      };
      environment.systemPackages = with pkgs; [
        gnome-keyring
        libsecret
      ];
      programs.dconf.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
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
