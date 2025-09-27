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
        userName = lib.mkDefault "${name}";
        userEmail = lib.mkDefault "${email}";
      };
    };
in
{
  config = {
    flake.nixosModules.${userName} = {
      users.users.${userName} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
        ];
        description = "${name}";
        initialPassword = "changeme";
      };
    };

    flake.modules.homeManager.${userName} = hmModule;
    autix.home.modules.${userName} = hmModule;
  };
}
