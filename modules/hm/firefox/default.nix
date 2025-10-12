{ inputs, ... }:
let
  firefoxExtensions =
    pkgs: with pkgs.nur.repos.rycee.firefox-addons; [
      darkreader
      ublock-origin
      bitwarden
      sponsorblock
      web-clipper-obsidian
      libredirect
      violentmonkey
      youtube-high-definition
      youtube-nonstop
    ];

  hmModule =
    { config
    , lib
    , pkgs
    , ...
    }:
    let
      inherit (config.home) username;
      homeDir = config.home.homeDirectory;

      xdgDirs = lib.attrByPath [ "xdg" "userDirs" ] { } config;
      desktopDir =
        let
          rawDesktop = xdgDirs.desktop or "${homeDir}/Desktop";
        in
        lib.replaceStrings [ "$HOME" ] [ homeDir ] rawDesktop;
      downloadDir =
        let
          rawDownload = xdgDirs.download or "${homeDir}/Downloads";
        in
        lib.replaceStrings [ "$HOME" "$XDG_DESKTOP_DIR" ] [ homeDir desktopDir ] rawDownload;

      policiesConfig = import ./_config/policies.nix { };
      prefsConfig = import ./_config/prefs.nix { inherit lib downloadDir; };
      searchConfig = import ./_config/search.nix { inherit lib pkgs; };
    in
    {
      programs.firefox = {
        enable = true;
        inherit (policiesConfig) policies;

        profiles.${username} = {
          id = 0;
          isDefault = true;
          path = username;
          settings = prefsConfig.profileSettings;
          search = searchConfig.searchConfig;
          extensions.packages = firefoxExtensions pkgs;
        };

        profiles.work = {
          id = 1;
          isDefault = false;
          path = "work";
          settings = prefsConfig.profileSettings;
          search = searchConfig.searchConfig;
          extensions.packages = firefoxExtensions pkgs;
        };
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "firefox.desktop" ];
          "text/xml" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        };
      };

      home.sessionVariables = {
        BROWSER = "${pkgs.firefox}/bin/firefox";
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      };
    };
in
{
  flake-file = {
    inputs = {
      nur.url = "github:nix-community/NUR";
      nur.inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  autix.aspects.firefox = {
    description = "Firefox config, including policies, profiles and NUR overlay extensions.";
    overlays.nur = inputs.nur.overlays.default;
    home = {
      targets = [ "albert-desktop" ];
      modules = [ hmModule ];
    };
  };
}
