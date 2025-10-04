{ lib, ... }:
let
  hmModule =
    { config, pkgs, ... }:
    lib.mkIf (config.autix.home.profile.graphical or false) {
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          WantedBy = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 1;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
in
{
  autix.aspects.polkit = {
    description = "Polkit agent for graphical sessions.";
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
