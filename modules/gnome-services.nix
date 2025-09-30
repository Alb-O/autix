_: {
  flake.nixosModules.gnome-services =
    { pkgs, ... }:
    {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services = {
        login.enableGnomeKeyring = true;
      };
      environment.systemPackages = with pkgs; [
        gnome-keyring
        libsecret # For secret storage API
      ];
      programs.dconf.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
    };
}
