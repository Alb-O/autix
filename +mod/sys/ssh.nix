_:
let
  hmModule =
    { lib, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          controlMaster = lib.mkDefault "auto";
          controlPersist = lib.mkDefault "10m";
          serverAliveInterval = lib.mkDefault 60;
          forwardAgent = lib.mkDefault true;
          extraOptions = {
            AddKeysToAgent = "yes";
            IdentityFile = "~/.ssh/id_ed25519";
          };
        };
      };
    };
in
{
  autix.aspects.ssh = {
    description = "SSH client defaults and server hardening.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [
        {
          services.openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
            };
          };
        }
      ];
    };
  };

  flake.nixosModules.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
