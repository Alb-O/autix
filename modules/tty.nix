_: {
  flake.nixosModules.tty =
    { config, pkgs, ... }:
    let
      fontBundle = config.autix.fonts;
      displayFont = fontBundle.roles.displayManager;
      monoFamily = displayFont.family;
    in
    {
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
    };
}
