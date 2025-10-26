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
        settings.user = {
          name = lib.mkDefault name;
          email = lib.mkDefault email;
        };
      };

      sops = {
        age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
        defaultSopsFile = ./secrets.yaml;
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

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
    };
  };
in
{
  flake.aspects =
    { aspects, ... }:
    {
      ${userName} = {
        description = "Base user configuration for ${name}.";
        includes = with aspects; [
          workspace
          git
          fzf
        ];
        homeManager.imports = [ hmModule ];
        nixos.imports = [ nixosModule ];
      };
    };

  autix.home.legacyBuilder.enable = false;
}
