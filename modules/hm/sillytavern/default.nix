_:
let
  hmModule =
    { config, pkgs, ... }:
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
      home.packages = [
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
    };
in
{
  flake.aspects.sillytavern = {
    description = "SillyTavern launcher and desktop entry.";
    homeManager = hmModule;
  };
}
