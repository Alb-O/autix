_:
let
  _p = builtins.pathExists ./_personal.nix;
  personal = if _p then import ./_personal.nix else { };
  userName = personal.user.username or "albert";
  name = personal.user.name or "Joe Mama";
  email = personal.user.email or "albert@example.com";
in
{
  flake.modules.nixos.${userName} = {
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
      description = "${name}";
      hashedPassword = personal.user.hashedPassword or null;
      initialPassword = personal.user.initialPassword or "changeme";
    };
  };

  flake.modules.homeManager.${userName} =
    { lib, pkgs, ... }:
    {
      home.username = lib.mkDefault userName;
      home.homeDirectory = lib.mkDefault "/home/${userName}";
      home.stateVersion = lib.mkDefault "24.05";

      programs.git = {
        enable = true;
        userName = lib.mkDefault "${name}";
        userEmail = lib.mkDefault "${email}";
        lfs.enable = lib.mkDefault true;
        aliases = lib.mkDefault {
          undo = "reset --soft HEAD~1";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          visual = "!gitk";
          cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d";
          branches = "branch -a";
          remotes = "remote -v";
        };
        ignores = lib.mkDefault [
          ".DS_Store"
          "Thumbs.db"
          "*~"
          "*.swp"
          "*.tmp"
          "node_modules/"
          "dist/"
          "build/"
          "target/"
          "result"
          "result-*"
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
}
