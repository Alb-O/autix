{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-file.flakeModules.nix-auto-follow
    inputs.files.flakeModules.default
  ];

  flake-file = {
    prune-lock = {
      enable = true;
      program = lib.mkForce (
        pkgs:
        pkgs.writeShellApplication {
          name = "nix-auto-follow";
          runtimeInputs = [ inputs.nix-auto-follow.packages.${pkgs.system}.default ];
          text = ''
            auto-follow "$1" > "$2"
          '';
        }
      );
    };
    do-not-edit = ''
      # DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
      # Use `nix run .#write-flake` to regenerate it.
      #
      #⠸⢾⣿⣿⣿⣧⠰⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢮⢃⣾⣿⣿⠀⠀
      #⠀⠀⣺⣿⣿⣿⠄⢃⡀⠀⠀⠀⢀⣀⡀⠀⠀⢀⠀⠠⠀⡀⠸⢃⣾⣿⠋⠉⠀⠀
      #⡀⢉⠿⠛⠉⣰⣼⣶⠍⡠⡾⢠⣷⣿⣿⣥⠀⠸⣖⡈⣦⣍⠲⣌⠻⢿⣷⢢⢀⣀
      #⣴⠀⢂⣤⣿⣿⠿⠁⡐⠞⠃⠨⣿⣽⣿⣻⡇⣾⡿⢇⠘⢽⣷⡈⢚⡆⠉⡚⣸⣿
      #⡋⠠⡀⠻⠟⠫⠁⠠⠜⠁⠂⠘⠱⢿⣿⣿⡇⢹⡟⠝⠘⠂⠙⠍⠀⠡⠀⠀⠻⠿
      #⢁⢟⣧⡀⠀⠂⢀⣠⣶⣶⣧⠰⣿⣿⣿⣿⡇⣸⣿⣷⢰⣷⣶⣦⡀⠀⢡⡶⠀⠿
      #⢬⣾⣿⣷⡎⣰⣿⣿⣿⣿⣿⣆⢳⣼⣿⣿⡇⢻⣿⠇⣼⣿⣿⣿⣿⣦⡀⠮⢁⠰
      #⣿⣿⣿⣿⠁⣿⣿⡿⠟⠛⠛⠿⣦⠹⣿⣿⢡⡘⢋⣴⡿⠿⠛⠻⠿⣿⡇⠘⡭⡀
      #⣟⣽⣿⣿⠸⠛⢁⣤⠠⠄⠀⠀⢨⣿⣦⣥⣾⣿⣿⣥⡄⠠⠀⠀⠀⣈⢑⠀⣿⠃
      #⢿⣿⣿⣿⢸⣦⣹⣿⣆⠰⠾⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠰⠿⣳⣧⣿⠀⢸⣶
      #⠊⢿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⢸⣿
      #⠐⠘⣿⣿⡈⣿⣿⣿⣿⣏⣛⠿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣋⣽⣿⣿⣿⠁⢸⡾
      #⠀⠀⠙⣿⣇⢹⣿⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣶⣶⣿⣿⣿⣿⣿⣿⣿⠏⠀⣎⡟
      #⣀⠠⣲⠀⠙⠂⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠠⠊⠀
      #⣿⡇⣿⠀⠀⠀⠀⠀⠀⠈⠉⠉⢉⡹⣿⣿⡟⣉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⢰⣥
      #
    '';
    inputs = {
      flake-file.url = "github:vic/flake-file";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      nixos-wsl.url = "github:nix-community/NixOS-WSL";
      nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
      files.url = "github:mightyiam/files";
    };
    outputs = lib.mkForce ''
      inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
        (inputs.import-tree [
          ./+mod
        ])
    '';
  };
}
