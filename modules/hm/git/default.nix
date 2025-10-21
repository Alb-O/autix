{ lib, ... }:
let
  giteaCredentials = "git/gitea/credentials";
  hmModule =
    { pkgs, config, ... }:
    {
      sops.secrets."${giteaCredentials}" = { };
      home.packages = with pkgs; [
        difftastic
        git-toolbelt
      ];
      programs.git = {
        enable = true;
        lfs.enable = true;
        ignores = [
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
        settings = {
          alias = {
            undo = "reset --soft HEAD~1";
            unstage = "reset HEAD --";
            last = "log -1 HEAD";
            visual = "!gitk";
            cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
            branches = "branch -a";
            remotes = "remote -v";
          };
          diff.external = "${pkgs.difftastic}/bin/difft";
          init.defaultBranch = "main";
          core = {
            editor = "kak";
            autocrlf = false;
            safecrlf = true;
            filemode = true;
          };
          help.autocorrect = 1;
          rerere.enabled = true;
          log.date = "relative";
          credential.helper = "store --file ${config.sops.secrets."${giteaCredentials}".path}";
          credential."https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
          credential."https://gist.github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
        };
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
  };
}
