let
  userName = "albert";
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
      description = "Albert";
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
        userName = lib.mkDefault "Albert";
        userEmail = lib.mkDefault "albert@example.com";
      };
    };
}
