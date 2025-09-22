{ pkgs, ... }:
{
  boot.kernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nouveau" ];

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];

  boot.kernelParams = [
    "video=DP-1:2560x1440@143.973"
    "video=DP-3:1920x1080@144.001"
  ];

  boot.extraModprobeConfig = ''
    options nouveau tv_disable=1
    options nouveau ignorelid=1
  '';

  # Graphics stack + Vulkan (NVK)
  hardware.graphics = {
    enable = true;
    # Enable 32-bit userspace for Vulkan (Steam/Wine).
    enable32Bit = true;
  };

  # Ensure NVIDIA firmware is available for nouveau.
  hardware.enableRedistributableFirmware = true;

  # Prefer NVK (nouveau Vulkan ICD) as the primary Vulkan driver.
  # Use the runtime OpenGL/Vulkan driver profile symlinks to avoid store-path mismatches.
  environment.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nouveau_icd.i686.json";
  };
}
