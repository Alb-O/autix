{ lib, ... }:
let
  hmModule =
    { config, pkgs, ... }:
    let
      localShare = "${config.home.homeDirectory}/.local/share";
    in
    {
      home.packages = lib.mkAfter [ pkgs.fzf ];

      home.file."${localShare}/rc/fzf.sh" = {
        text = ''
          # FZF configuration with minimal Tokyo Night theme

          export FZF_DEFAULT_OPTS="
            --height 40%
            --layout=reverse
            --border=none
            --info=inline
            --prompt='$ '
            --pointer='>'
            --marker='✶'
            --no-scrollbar
            --no-separator
            --color=bg:#1a1b26,bg+:#292e42,fg:#c0caf5,fg+:#c0caf5:bold
            --color=hl:#7aa2f7,hl+:#7aa2f7:bold,info:#7c7d83,marker:#9ece6a:bold
            --color=prompt:#7aa2f7,spinner:#bb9af7,pointer:#f7768e,header:#73daca
            --color=gutter:#1a1b26
          "

          export FZF_DEFAULT_COMMAND="rg --files"
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

          export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
          export FZF_ALT_C_OPTS="--preview 'eza --tree --icons {} | head -200'"
        '';
        executable = false;
      };
    };
in
{
  autix.home.modules.fzf = hmModule;
}
