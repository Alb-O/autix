{ config, ... }:
{
  settings = {
    inherit (config.autix) mcp;
    tools = {
      "Mcp-Nixos*" = false;
    };
  };
}
