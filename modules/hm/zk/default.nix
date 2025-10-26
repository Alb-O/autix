_:
let
  hmModule = _: {
    programs.zk = {
      enable = true;
      settings = {
        note = {
          language = "en";
          "default-title" = "Untitled";
          filename = "{{id}}";
          extension = "md";
          template = "default.md";
          "id-charset" = "alphanum";
          "id-length" = 4;
          "id-case" = "lower";
        };

        format = {
          markdown = {
            hashtags = true;
            "colon-tags" = true;
          };
        };

        tool = {
          pager = "less -FIRX";
          "fzf-preview" = "bat -p --color always {-1}";
        };

        lsp = {
          diagnostics = {
            "wiki-title" = "hint";
            "dead-link" = "error";
          };
        };

        alias = {
          # Edit the last modified note
          el = "zk edit --limit 1 --sort modified- $@";

          # List note paths
          paths = "zk list --format \"'{{path}}'\" --quiet --delimiter ' ' $@";

          # Edit notes from the last two weeks (interactive)
          recent = "zk edit --sort created- --created-after 'last two weeks' --interactive";
        };
      };
    };
    xdg.configFile."zk/templates/default.md".source = ./templates/default.md;
  };
in
{
  flake.aspects.zk = {
    description = "Zettelkasten CLI (zk) configuration.";
    homeManager = hmModule;
  };
}
