{
  flake.modules.nixos.system-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        git
        curl
        wget
      ];
    };
}
