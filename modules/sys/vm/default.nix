_:
/*
  let
   pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    pkgsAarch64 = import inputs.nixpkgs { system = "aarch64-linux"; };

    iso =
      (pkgsAarch64.nixos {
        imports = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix" ];
      }).config.system.build.isoImage;

    vmScript = pkgs.writeScriptBin "run-nixos-vm" ''
      #!${pkgs.runtimeShell}
      ${pkgs.qemu}/bin/qemu-system-aarch64 \
        -machine virt,gic-version=max \
        -cpu max \
        -m 2G \
        -smp 4 \
        -drive file=$(echo ${iso}/iso/*.iso),format=raw,readonly=on \
        -nographic \
        -bios ${pkgsAarch64.OVMF.fd}/FV/QEMU_EFI.fd
    '';

    nixosModule = _: {
      environment.systemPackages = [ vmScript ];
      programs.virt-manager.enable = true;
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
    };
    hmModule = _: {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };

  in
*/
{
  autix.aspects.vm = {
    description = "Virtualisation";
    nixos = {
      targets = [ "*" ];
      modules = [ { boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; } ];
    };
    /*
      home = {
         targets = [ "*" ];
         modules = [ hmModule ];
       };
    */
  };
}
