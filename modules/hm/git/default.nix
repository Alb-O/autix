{ lib, ... }:
let
  inherit (lib)
    mkDefault;

  secretName = "git/gitea/credentials";

  # The main home-manager module that configures git
  hmModule =
    { pkgs, config, ... }:
    {
      autix.sops-nix.sharedSecrets."${secretName}" = { };

      programs.git =
        let
          secret = config.autix.sops-nix.sharedSecrets."${secretName}";
        in
        {
          enable = mkDefault true;
          lfs.enable = mkDefault true;
          aliases = mkDefault {
            undo = "reset --soft HEAD~1";
            unstage = "reset HEAD --";
            last = "log -1 HEAD";
            visual = "!gitk";
            cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
            branches = "branch -a";
            remotes = "remote -v";
          };
          ignores = mkDefault [
            ".DS_Store"
            "Thumbs.db"
            "*~"
            "*.swp"
            "*.tmp"
            "*.log"
            "*.blend1"
            "node_modules/"
            "dist/"
            "target/"
          ];
          extraConfig = {
            init.defaultBranch = "main";
            core = {
              editor = "kak";
              autocrlf = false;
              safecrlf = true;
              filemode = true;
            };
            pull = {
              rebase = false;
              ff = "only";
            };
            status = {
              showUntrackedFiles = "all";
              submoduleSummary = true;
            };
            color = {
              ui = "auto";
              branch = "auto";
              diff = "auto";
              status = "auto";
            };
            help.autocorrect = 1;
            rerere.enabled = true;
            log.date = "relative";
            # Access hyphenated attributes with quoted keys
            credential.helper = "store --file ${secret.path}";
            credential."https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
            credential."https://gist.github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
          };
        };
    };

  nixosModule =
    { ... }:
    {
      autix.sops-nix.sharedSecrets."${secretName}" = {
        mode = "0660";
      };
    };
in
{
  autix.aspects.git = {
    description = "Git configuration with helpful defaults.";
    home = {
      targets = [ "*" ];
      modules = [ hmModule ];
    };
    nixos = {
      targets = [ "*" ];
      modules = [ nixosModule ];
    };
  };
}
