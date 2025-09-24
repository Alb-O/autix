{ lib, ... }:
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      controlMaster = lib.mkDefault "auto";
      controlPersist = lib.mkDefault "10m";
      serverAliveInterval = lib.mkDefault 60;
      forwardAgent = lib.mkDefault true;

      extraConfig = lib.mkDefault ''
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
      '';

      matchBlocks."*".addKeysToAgent = "yes";
    };
  };
}
