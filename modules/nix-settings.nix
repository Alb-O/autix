{
  flake.modules.nixos.nix-settings =
    { pkgs, config, ... }:
    {
      nix = {
        optimise.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
        gc = pkgs.lib.optionalAttrs config.nix.enable {
          automatic = true;
          options = "--delete-older-than 7d";
        };
        channel.enable = false;
      };
      nixpkgs.config.allowUnfree = true;
    };
}
