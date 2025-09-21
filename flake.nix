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
  description = "The cure to my autixm";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    warn-dirty = false;
  };

  inputs = {
    allfollow = {
      url = "github:spikespaz/allfollow";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/home-manager";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

}
