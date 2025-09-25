{ lib, ... }:
let
  hmModule =
    { config, pkgs, ... }:
    let
      cfgHome = config.xdg.configHome;
      inherit (config.xdg) stateHome;
      inherit (config.xdg) dataHome;
      inherit (config.xdg) cacheHome;

      mkVars = prefix: mapping: lib.mapAttrs (_: value: "${prefix}/${value}") mapping;

      sessionVars =
        mkVars stateHome {
          HISTFILE = "bash/history";
          PYTHON_HISTORY = "python/python_history";
        }
        // mkVars dataHome {
          CARGO_HOME = "cargo";
          DOTNET_CLI_HOME = "dotnet";
          NB_DIR = "nb";
          GOPATH = "go";
          UNISON = "unison";
          PYTHONUSERBASE = "python";
        }
        // mkVars cacheHome {
          CUDA_CACHE_PATH = "nv";
          XCOMPOSECACHE = "X11/xcompose";
          NPM_CONFIG_CACHE = "npm";
          PYTHONPYCACHEPREFIX = "python";
        }
        // mkVars cfgHome {
          GTK2_RC_FILES = "gtk-2.0/gtkrc";
          NPM_CONFIG_INIT_MODULE = "npm/config/npm-init.js";
          NBRC_PATH = "nbrc";
          PYTHONSTARTUP = "python/pythonrc.py";
          XCOMPOSEFILE = "X11/xcompose";
        };

      yaziWrapper = pkgs.writeShellScript "xdg-yazi-wrapper" ''
        set -eu

        multiple="$1"
        directory="$2"
        save="$3"
        path="$4"
        out="$5"

        if [ "$save" = "1" ]; then
          set -- --chooser-file="$out" "$path"
        elif [ "$directory" = "1" ]; then
          set -- --chooser-file="$out" --cwd-file="$out"".1" "$path"
        elif [ "$multiple" = "1" ]; then
          set -- --chooser-file="$out" "$path"
        else
          set -- --chooser-file="$out" "$path"
        fi

        exec kitty --title 'XDG File Picker' ${pkgs.yazi}/bin/yazi "$@"

        if [ "$directory" = "1" ] && [ ! -s "$out" ] && [ -s "$out"".1" ]; then
          cat "$out"".1" > "$out"
          rm "$out"".1"
        fi
      '';
    in
    {
      nix = {
        enable = true;
        settings.use-xdg-base-directories = true;
        package = lib.mkDefault pkgs.nix;
      };

      home = {
        packages = lib.mkAfter [
          pkgs.kitty
          pkgs.xdg-desktop-portal-termfilechooser
        ];

        preferXdgDirectories = true;

        sessionVariables = lib.mkMerge [ sessionVars ];

        file = {
          "${cfgHome}/xdg-desktop-portal-termfilechooser/config".text = ''
            [filechooser]
            cmd=$XDG_CONFIG_HOME/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
            default_dir=$HOME
            env=TERMCMD=kitty --title 'XDG File Picker'
            open_mode=suggested
            save_mode=suggested
          '';

          "${cfgHome}/xdg-desktop-portal/portals.conf".text = ''
            [preferred]
            org.freedesktop.impl.portal.FileChooser=termfilechooser
          '';

          "${cfgHome}/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
            source = yaziWrapper;
            executable = true;
          };

          "${cfgHome}/npm/config/.keep".text = "";
          "${stateHome}/python/.keep".text = "";
          "${dataHome}/python/.keep".text = "";
          "${cacheHome}/python/.keep".text = "";
          "${stateHome}/bash/.keep".text = "";
        };
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "${config.home.homeDirectory}/desktop";
          documents = "${config.home.homeDirectory}/desktop/docs";
          download = "${config.home.homeDirectory}/desktop/dl";
          music = "${config.home.homeDirectory}/desktop/music";
          pictures = "${config.home.homeDirectory}/desktop/pics";
          videos = "${config.home.homeDirectory}/desktop/vids";
          templates = "${config.home.homeDirectory}/desktop/templates";
          publicShare = "${config.home.homeDirectory}/desktop/public";
        };
      };

      accounts = {
        calendar.basePath = lib.mkDefault "${dataHome}/calendar";
        contact.basePath = lib.mkDefault "${dataHome}/contacts";
      };

      targets.genericLinux.enable = lib.mkForce false;
      programs.man.enable = false;
    };
in
{
  config = {
    flake.modules.homeManager.xdg = hmModule;
    autix.home.modules.xdg = hmModule;
  };
}
