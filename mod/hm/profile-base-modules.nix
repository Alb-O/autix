{ lib, ... }:
{
  config.autix.home.profile.baseModules = lib.mkDefault [
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
}
