_:
let
  hmModule = _: {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          theme = {
            authorColors = {
              "*" = "blue";
            };
            activeBorderColor = [
              "default"
              "bold"
            ];
            inactiveBorderColor = [ "#373737" ];
            selectedLineBgColor = [
              "#303030"
              "bold"
            ];
            optionsTextColor = [ "default" ];
          };
          scrollHeight = 2;
          scrollPastBottom = true;
          tabWidth = 2;
          mouseEvents = true;
          sidePanelWidth = 0.3333;
          language = "auto";
          timeFormat = "02 Jan 06";
          shortTimeFormat = "3:04PM";
          showListFooter = true;
          showFileTree = true;
          showCommandLog = true;
          showBottomLine = true;
          commandLogSize = 8;
          border = "single";
          nerdFontsVersion = "3";
          showFileIcons = true;
        };
        git = {
          paging = {
            colorArg = "always";
            pager = "";
          };
          commit = {
            signOff = false;
            autoWrapCommitMessage = true;
            autoWrapWidth = 72;
          };
          merging = {
            manualCommit = false;
            args = "";
          };
          mainBranches = [
            "master"
            "main"
          ];
          autoFetch = true;
          autoRefresh = true;
          fetchAll = true;
          branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
          allBranchesLogCmds = [
            "git log --graph --all --color=always --abbrev-commit --decorate --date=relative --pretty=medium"
          ];
          log = {
            order = "topo-order";
            showGraph = "always";
            showWholeGraph = false;
          };
        };
        os = {
          editPreset = "kak";
          open = "xdg-open {{filename}} >/dev/null";
        };
        keybinding = {
          universal = {
            quit = "q";
            return = "<esc>";
            nextItem = "<down>";
            prevItem = "<up>";
            "nextItem-alt" = "j";
            "prevItem-alt" = "k";
            goInto = "<enter>";
            confirm = "<enter>";
            remove = "d";
            new = "n";
            edit = "e";
            openFile = "o";
            executeShellCommand = ":";
            refresh = "R";
            nextTab = "]";
            prevTab = "[";
            undo = "z";
            redo = "Z";
          };
          files = {
            commitChanges = "c";
            ignoreFile = "i";
            refreshFiles = "r";
            stashAllChanges = "s";
            toggleStagedAll = "a";
          };
          branches = {
            checkoutBranchByName = "c";
            rebaseBranch = "r";
            mergeIntoCurrentBranch = "M";
          };
          commits = {
            squashDown = "s";
            renameCommit = "r";
            pickCommit = "p";
            revertCommit = "t";
            cherryPickCopy = "C";
            pasteCommits = "V";
          };
        };
      };
    };
  };
in
{
  config = {
    flake.modules.homeManager.lazygit = hmModule;
    autix.home.modules.lazygit = hmModule;
  };
}
