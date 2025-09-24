{ lib, ... }:
let
  hmModule =
    { config, pkgs, ... }:
    lib.mkIf (config.autix.home.profile.graphical or false) (
      let
        localBin = "${config.home.homeDirectory}/.local/bin";
        localShare = "${config.home.homeDirectory}/.local/share";
        wrapper = pkgs.writeShellScript "sillytavern-start" ''
          #!${pkgs.bash}/bin/bash
          export SILLYTAVERN_DATAROOT="${localShare}/sillytavern"
          mkdir -p "$SILLYTAVERN_DATAROOT"
          cd ${pkgs.sillytavern}/opt/sillytavern
          exec ${pkgs.nodejs_22}/bin/node server.js "$@"
        '';
      in
      {
        home.packages = lib.mkAfter [
          pkgs.sillytavern
          pkgs.kitty
        ];

        home.file."${localBin}/sillytavern-start" = {
          source = wrapper;
          executable = true;
        };

        xdg.desktopEntries.sillytavern = {
          name = "SillyTavern";
          comment = "LLM Frontend for Power Users";
          icon = "applications-games";
          exec = "kitty ${localBin}/sillytavern-start";
          categories = [
            "Network"
            "Chat"
            "Development"
          ];
          terminal = true;
          type = "Application";
          startupNotify = true;
        };
      }
    );
in
{
  config = {
    flake.modules.homeManager.sillytavern = hmModule;
    autix.home.modules.sillytavern = hmModule;
  };
}
