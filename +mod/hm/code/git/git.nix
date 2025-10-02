{ lib, ... }:
let
  inherit (lib) mkDefault;

  hmModule =
    { pkgs, ... }:
    {
      programs.git = {
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
          credential."https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
          credential."https://gist.github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
        };
      };
    };
in
{
  autix.home.modules.git = hmModule;
}
