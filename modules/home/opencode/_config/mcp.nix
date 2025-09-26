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
    tools = {
      "Mcp-Nixos*" = false;
    };
  };
  packages = with pkgs; [
    mcp-nixos
  ];
}
