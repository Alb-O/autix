{ pkgs, ... }:
{
  settings = {
    mcp = {
      mcp-nixos = {
        type = "local";
        command = [ "mcp-nixos" ];
        enabled = true;
      };
    };
  };
  packages = with pkgs; [
    mcp-nixos
  ];
}
