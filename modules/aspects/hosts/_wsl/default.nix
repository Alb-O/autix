_: {
  # Host-specific WSL configuration
  # General WSL settings are configured in the wsl aspect (modules/sys/wsl)

  system.stateVersion = "24.11";
  wsl.defaultUser = "albert";
  networking.hostName = "wsl";
  security.sudo.wheelNeedsPassword = false;
}
