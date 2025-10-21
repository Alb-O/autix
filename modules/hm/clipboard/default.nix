{ lib, ... }:
let
  hmModule =
    { pkgs, ... }:
    let
      clipboardService = {
        Unit = {
          Description = "Clipboard manager for Wayland";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
          RestartSec = 5;
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    in
    {
      home.packages = with pkgs; [
        wl-clipboard
        cliphist
      ];

      systemd.user.services.cliphist = clipboardService;
      home.sessionVariables = {
        CLIPHIST_DB_PATH = lib.mkDefault "$HOME/.local/share/cliphist/db";
      };
    };
in
{
  autix.aspects.clipboard = {
    description = "Wayland clipboard manager service.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
