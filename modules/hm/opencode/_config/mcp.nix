{ pkgs, config, ... }:
{
  settings = {
    mcp = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers = {
          "CONTEXT7_API_KEY" = builtins.readFile config.sops.secrets."context7/api-key".path;
        };
        enabled = true;
      };
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
