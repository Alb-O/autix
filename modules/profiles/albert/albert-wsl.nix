_: {
  autix.home.profiles."albert-wsl" = {
    user = "albert";
    system = "x86_64-linux";
    aspect = "albert";
    buildWithLegacyHomeManager = false;
    den = {
      enable = true;
      description = "Albert's WSL environment (flake-aspects prototype).";
    };
  };
}
