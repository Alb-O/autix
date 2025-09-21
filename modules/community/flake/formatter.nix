{
  perSystem.treefmt.projectRootFile = "flake.nix";
  perSystem.treefmt.programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
  };
}
