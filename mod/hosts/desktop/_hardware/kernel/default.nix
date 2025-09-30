{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    kernelModules = [
      "kvm-amd"
      "hid-logitech-dj"
      "hid-logitech-hidpp"
    ];
  };
}
