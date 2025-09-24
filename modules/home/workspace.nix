{
  lib,
  config,
  ...
}:
let
  isGraphical = config.autix.home.profile.graphical or false;
  homeDir = config.home.homeDirectory;
  localBin = "${homeDir}/.local/bin";
  cargoBin = "${homeDir}/.local/share/cargo/bin";
in
{
  flake.modules.homeManager.workspace = {
    home.sessionPath = lib.mkAfter [
      localBin
      cargoBin
    ];

    home.sessionVariables = lib.mkMerge [
      {
        USERNAME = lib.mkDefault config.home.username;
        EDITOR = lib.mkDefault "kak";
      }
      (lib.mkIf (config.autix.home.profile.name != null) {
        HOSTNAME = lib.mkDefault config.autix.home.profile.name;
      })
      (lib.mkIf isGraphical {
        TERMINAL = lib.mkDefault "wezterm";
        TERM = lib.mkDefault "wezterm";
      })
    ];

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.bash.enable = lib.mkForce false;
  };
}
