_:
let
  userName = "albert";
  name = "Albert O'Shea";
  email = "albertoshea2@gmail.com";

  hmModule =
    { lib, ... }:
    {
      home.username = lib.mkDefault userName;
      home.homeDirectory = lib.mkDefault "/home/${userName}";
      home.stateVersion = lib.mkDefault "24.05";

      programs.git = {
        userName = lib.mkDefault name;
        userEmail = lib.mkDefault email;
      };
    };

  nixosModule = {
    time.timeZone = "Australia/Hobart";
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
      description = name;
      initialPassword = "changeme";
    };
  };
in
{
  autix.aspects.${userName} = {
    description = "Base user configuration for ${name}.";
    home = {
      targets = [
        "albert-desktop"
        "albert-wsl"
      ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [
        "desktop"
        "wsl"
      ];
      modules = [ nixosModule ];
    };
  };
}
