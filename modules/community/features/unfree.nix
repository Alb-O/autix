{

  flake.modules.nixos.unfree =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;
    };

}
