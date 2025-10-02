{ lib, config, ... }:
{
  settings = {
    # Formatters managed by the centralized formatter.nix module
    formatter = lib.mapAttrs (_name: formatter: {
      inherit (formatter) command extensions;
    }) config.autix.formatter.formatters;
  };
}
