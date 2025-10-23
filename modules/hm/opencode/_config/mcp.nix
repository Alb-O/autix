{ config, ... }:
{
  settings = {
    inherit (config.autix) mcp;
    tools = {
      "mcp-nixos_*" = false;
      "context7_*" = false;
    };
  };
}
