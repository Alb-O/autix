_: {
  autix.home.profiles."albert-desktop" = {
    user = "albert";
    system = "x86_64-linux";
    aspect = "albert";
    buildWithLegacyHomeManager = false;
    den = {
      enable = true;
      description = "Albert's desktop environment (flake-aspects prototype).";
    };
  };
}
