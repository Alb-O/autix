{ inputs, lib, ... }:
let
  userName = "albert";
  name = "Albert O'Shea";
  email = "albertoshea2@gmail.com";
  homeManagerNixosModule = inputs.home-manager.nixosModules.home-manager;
  aggregatedHomeModule = inputs.self.modules.homeManager.${userName};

  hmModule =
    { config
    , lib
    , ...
    }:
    {
      home.username = lib.mkDefault userName;
      home.homeDirectory = lib.mkDefault "/home/${userName}";
      home.stateVersion = lib.mkDefault "24.11";
      programs.git = {
        settings.user = {
          name = lib.mkDefault name;
          email = lib.mkDefault email;
        };
      };

      sops = {
        age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
        defaultSopsFile = ./albert-secrets.yaml;
      };
    };

  nixosModule =
    { ... }:
    {
      imports = [ homeManagerNixosModule ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${userName}.imports = [ aggregatedHomeModule ];
      };

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
        defaultSopsFile = ./albert-secrets.yaml;
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
        includes =
          let
            base = [ aspects.fonts ];
            autoNames = builtins.filter
              (
                name:
                name != userName
                && name != "fonts"
                && name != "state-version"
                && name != "wsl"
                && (builtins.match "^host-" name == null)
                && (aspects.${name} ? homeManager)
              )
              (builtins.attrNames aspects);
          in
          base ++ map (name: aspects.${name}) autoNames;
        homeManager = hmModule;
        nixos = nixosModule;
      };
    };
}
