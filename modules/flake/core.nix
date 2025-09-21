{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file = {
    description = "The cure to my autixm";
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
    nixConfig = {
      warn-dirty = false;
    };
    inputs = {
      flake-file.url = "github:vic/flake-file";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
