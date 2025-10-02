_: {
  flake.nixosModules.desktop = {
    imports = [
      ./_conf
    ];
  };
}
