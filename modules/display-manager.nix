_:
{
  flake.modules.nixos.display-manager =
    { config, pkgs, ... }:
    let
      fontBundle = config.autix.fonts;
      displayFont = fontBundle.roles.displayManager;
      monoFamily = displayFont.family;
    in
    {
      services.displayManager = {
        enable = true;
        ly = {
          enable = true;
          settings = {
            animation = "matrix";
          };
        };
      };

      services.kmscon = {
        enable = true;
        fonts = [
          {
            inherit (monoFamily) name;
            inherit (monoFamily) package;
          }
        ];
        extraConfig = "font-size=${toString displayFont.size}";
      };

      programs.dconf.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
