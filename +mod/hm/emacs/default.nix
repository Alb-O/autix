{ inputs, ... }:
let
  hmModule =
    { pkgs, ... }:
    let
      emacsPackage =
        with pkgs;
        (emacsWithPackagesFromUsePackage {
          package = emacs-unstable-pgtk;
          config = "";
        });
    in
    {
      services.emacs = {
        enable = true;
        package = emacsPackage;
        socketActivation.enable = true;
        client.enable = true;
        startWithUserSession = true;
      };
      programs.emacs = {
        enable = true;
        package = emacsPackage;
      };
    };
  flake-file = {
    inputs = {
      emacs-overlay.url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
in
{
  autix.home.modules.emacs = hmModule;
  flake.overlays.emacs = inputs.emacs-overlay.overlays.emacs;
  inherit flake-file;
}
