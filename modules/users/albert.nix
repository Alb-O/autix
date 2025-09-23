_:
let
  _p = builtins.pathExists ./_personal.nix;
  personal = if _p then import ./_personal.nix else { };
  userName = personal.user.username or "albert";
  name = personal.user.name or "Joe Mama";
  email = personal.user.email or "albert@example.com";
in
{
  flake.modules.nixos.${userName} = {
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
      description = "${name}";
      hashedPassword = personal.user.hashedPassword or null;
      initialPassword = personal.user.initialPassword or "changeme";
    };
  };

  flake.modules.homeManager.${userName} =
    { lib, ... }:
    {
      home.username = lib.mkDefault userName;
      home.homeDirectory = lib.mkDefault "/home/${userName}";
      home.stateVersion = lib.mkDefault "24.05";

      programs.git = {
        enable = true;
        userName = lib.mkDefault "${name}";
        userEmail = lib.mkDefault "${email}";
      };
    };
}
