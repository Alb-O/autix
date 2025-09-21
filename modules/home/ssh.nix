{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
      serverAliveInterval = 60;
      forwardAgent = true;

      extraConfig = ''
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
      '';
    };
  };
}
