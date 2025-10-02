_: {
  flake.nixosModules.dm = {
    services.displayManager = {
      enable = true;
      gdm = {
        enable = true;
      };
    };
  };
}
