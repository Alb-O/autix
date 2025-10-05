{ lib, ... }:
let
  hmModule =
    { config, ... }:
    let
      homeDir = config.home.homeDirectory;
      localBin = "${homeDir}/.local/bin";
      cargoBin = "${homeDir}/.local/share/cargo/bin";
    in
    {
      home.sessionPath = lib.mkAfter [
        localBin
        cargoBin
      ];

      home.sessionVariables = lib.mkMerge [
        {
          USERNAME = lib.mkDefault config.home.username;
          EDITOR = lib.mkDefault "kak";
          TERMINAL = lib.mkDefault "kitty";
          TERM_PROGRAM = lib.mkDefault "kitty";
        }
        (lib.mkIf (config.autix.home.profile.name != null) {
          HOSTNAME = lib.mkDefault config.autix.home.profile.name;
        })
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fish.enable = lib.mkDefault true;
      programs.bash.enable = lib.mkForce false;
    };
in
{
  autix.aspects.workspace = {
    description = "Session environment defaults for shells and direnv.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
  };
}
