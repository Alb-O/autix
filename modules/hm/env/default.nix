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

      home.sessionVariables =
        let
          profileName = lib.attrByPath [ "autix" "home" "profile" "name" ] null config;
        in
        lib.mkMerge [
          {
            USERNAME = lib.mkDefault config.home.username;
            EDITOR = lib.mkDefault "kak";
            TERMINAL = lib.mkDefault "kitty";
            TERM_PROGRAM = lib.mkDefault "kitty";
          }
          (lib.mkIf (profileName != null) {
            HOSTNAME = lib.mkDefault profileName;
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
  flake.aspects.workspace = {
    description = "Session environment defaults for shells and direnv.";
    homeManager = hmModule;
  };
}
