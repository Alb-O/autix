{
  den.hosts.x86_64-linux = {
    desktop = {
      description = "Primary workstation running full NixOS.";
      aspect = "host-desktop";
      users.albert = { };
    };

    wsl = {
      description = "Windows Subsystem for Linux environment.";
      aspect = "host-wsl";
      users.albert = { };
    };
  };
}
