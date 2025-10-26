{
  flake.aspects =
    { aspects, ... }:
    {
      host-desktop = {
        description = "Aspect tree for the primary desktop host.";
        includes = [
          aspects."state-version"
          aspects."nix-settings"
          aspects.essential
          aspects.networking
          aspects."shell-init"
          aspects."sops-nix"
          aspects.graphical
          aspects.wayland
          aspects.gdm
          aspects."gnome-services"
          aspects.ssh
          aspects.albert
        ];
        nixos.imports = [ ./hosts/_desktop ];
      };

      host-wsl = {
        description = "Aspect tree for the WSL-based environment.";
        includes = [
          aspects."state-version"
          aspects."nix-settings"
          aspects.essential
          aspects.cli
          aspects."shell-init"
          aspects."sops-nix"
          aspects.wsl
          aspects.albert
        ];
        nixos.imports = [ ./hosts/_wsl ];
      };
    };
}
