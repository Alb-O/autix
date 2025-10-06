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

      # SOPS configuration for secrets management
      sops = {
        age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../../secrets/secrets.yaml;
        
        # Example secrets - uncomment to use
        # secrets.example_api_key = { };
        # secrets.example_password = { };
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

    # SOPS configuration for system-level secrets
    # sops = {
    #   defaultSopsFile = ../../../secrets/secrets.yaml;
    #   age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
    #   
    #   # Example system secrets
    #   # secrets.example_system_secret = { };
    # };
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
