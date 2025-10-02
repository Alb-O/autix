_:
let
  envDefaults = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    # Fall back to a predictable compositor socket when the session does not provide one.
    WAYLAND_DISPLAY = "\${WAYLAND_DISPLAY:-wayland-1}";
  };

  mkDefaultEnv = lib: lib.mapAttrs (_: lib.mkDefault) envDefaults;

  nixosModule =
    { lib, ... }:
    {
      # Export Wayland-focused defaults to login shells and systemd-managed sessions.
      environment.variables = mkDefaultEnv lib;
      environment.sessionVariables = mkDefaultEnv lib;

      # Default to a pure Wayland setup; other modules can override if they require X11.
      services.xserver.enable = lib.mkDefault false;
    };

  hmModule =
    { lib, config, ... }:
    let
      isGraphical = config.autix.home.profile.graphical or false;
    in
    lib.mkIf isGraphical {
      home.sessionVariables = mkDefaultEnv lib;
      systemd.user.sessionVariables = mkDefaultEnv lib;
    };
in
{
  autix.home.modules.wayland = hmModule;

  flake = {
    homeModules.wayland = hmModule;
    nixosModules.wayland = nixosModule;
  };
}
