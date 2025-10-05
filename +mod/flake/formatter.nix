{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { config, ... }:
    {
      formatter = config.treefmt.build.wrapper;
      treefmt = {
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          stylua.enable = true;
          shfmt.enable = true;
          black.enable = true;
        };
        settings.global.excludes = [
          "flake.lock"
          ".envrc"
          ".leaderrc"
          "**/.gitignore"
          "*.example"
          "*.kdl"
          "*.kak"
          "**/kakrc"
          "justfile"
          "**/.keep"
          "*.org"
        ];
      };
    };
}
