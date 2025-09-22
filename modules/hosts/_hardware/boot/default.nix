_: {
  boot = {
    # Disable USB autosuspend to prevent mouse detection issues
    # Force use of acpi-cpufreq instead of amd_pstate to prevent initialization errors
    kernelParams = [
      "usbcore.autosuspend=-1"
      "processor.ignore_ppc=1"
      "initcall_blacklist=amd_pstate_init"
    ];

    supportedFilesystems = [ "ntfs" ];

    loader = {
      systemd-boot.enable = false;
      limine.enable = true;
      limine.extraConfig = "timeout: 0";
      efi.canTouchEfiVariables = true;
    };
  };
}
