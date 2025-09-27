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

  autix = {
    home.modules.${userName} = hmModule;
  };

  flake = {
    modules.homeManager = autix.home.modules;

    nixosModules.${userName} = {
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
in
{
  inherit autix flake;
}
