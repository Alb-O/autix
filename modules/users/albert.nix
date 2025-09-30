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
in
{
  autix.home.modules.${userName} = hmModule;

  flake = {
    nixosModules.${userName} = {
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
  };
}
