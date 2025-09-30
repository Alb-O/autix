_: {
  flake.nixosModules.dm = {
    services.displayManager = {
      enable = true;
      ly = {
        enable = true;
        settings = {
          animation = "matrix";
        };
      };
    };
  };
}
