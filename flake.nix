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
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-substituters = [ ];
    extra-trusted-public-keys = [ ];
  };

  inputs = {
    files = {
      url = "github:mightyiam/files";
    };
    flake-aspects = {
      url = "github:vic/flake-aspects";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    git-sparta = {
      url = "github:Alb-O/git-sparta";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

}
