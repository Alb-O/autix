{ config, ... }:
{
  flake.modules.homeManager = config.autix.home.modules;
}
