{
  pkgs,
  lib,
  ...
}: {
  searchConfig = {
    force = true;
    default = "google";

    engines = {
      # Nix ecosystem searches
      nix-packages = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@np"];
      };

      nixos-options = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@no"];
      };

      nixos-wiki = {
        urls = [
          {
            template = "https://nixos.wiki/index.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@nw"];
      };

      nixpkgs-issues = {
        urls = [
          {
            template = "https://github.com/NixOS/nixpkgs/issues";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@ni"];
      };

      home-manager-options = {
        urls = [
          {
            template = "https://home-manager-options.extranix.com";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@hm"];
      };

      # Development searches
      github = {
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
              {
                name = "type";
                value = "repositories";
              }
            ];
          }
        ];
        icon = "https://github.com/favicon.ico";
        definedAliases = ["@gh"];
      };

      stackoverflow = {
        urls = [
          {
            template = "https://stackoverflow.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://stackoverflow.com/favicon.ico";
        definedAliases = ["@so"];
      };

      mdn = {
        urls = [
          {
            template = "https://developer.mozilla.org/en-US/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://developer.mozilla.org/favicon-48x48.png";
        definedAliases = ["@mdn"];
      };

      # General searches
      youtube = {
        urls = [
          {
            template = "https://www.youtube.com/results";
            params = [
              {
                name = "search_query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://www.youtube.com/favicon.ico";
        definedAliases = ["@yt"];
      };

      wikipedia = {
        urls = [
          {
            template = "https://en.wikipedia.org/wiki/Special:Search";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://en.wikipedia.org/favicon.ico";
        definedAliases = ["@w"];
      };
    };
  };
}
