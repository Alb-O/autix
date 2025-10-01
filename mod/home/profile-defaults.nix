{ lib, ... }:
let
  inherit (lib) mkOption types;

  baseModules = [
    "fonts"
    "kitty"
    "essential-pkgs"
    "networking"
    "ssh"
    "git"
    "workspace"
    "xdg"
    "fzf"
    "zoxide"
    "lsp"
    "formatter"
    "opencode"
    "codex"
    "gemini"
    "mpv"
    "yazi"
    "lazygit"
    "nh"
    "zk"
    "kakoune"
  ];
in
{
  options.autix.home.profileDefaults.baseModules = mkOption {
    type = types.listOf types.str;
    default = baseModules;
    description = "Default set of home-manager aspect names included for every profile.";
  };
}
