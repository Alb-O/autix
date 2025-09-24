_:
let
  hmModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      homeCfg = config.home;
      username =
        homeCfg.username or (throw "firefox-module: set home.username before importing this module");
      homeDir =
        homeCfg.homeDirectory
          or (throw "firefox-module: set home.homeDirectory before importing this module");

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

      policiesConfig = import ./_data/policies.nix { };
      extensionsConfig = import ./_data/extensions.nix { };
      profileConfig = import ./_data/profile.nix { inherit lib downloadDir; };
      searchConfig = import ./_data/search.nix { inherit lib pkgs; };
    in
    {
      programs.firefox = {
        enable = true;
        policies = policiesConfig.policies // {
          ExtensionSettings = extensionsConfig.extensionSettings;
        };

        profiles.${username} = {
          id = 0;
          isDefault = true;
          path = username;
          settings = profileConfig.profileSettings;
          search = searchConfig.searchConfig;
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
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      };
    };
in
{
  config = {
    flake.modules.homeManager.firefox = hmModule;
    autix.home.modules.firefox = hmModule;
  };
}
