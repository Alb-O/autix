{ config, ... }:
let
  inherit (config.text.readme) parts;

  # Combine all README parts into a single document
  readmeContent = ''
    # Autix

    A modular NixOS and Home Manager configuration using the aspect system.

    ${parts.project-structure or ""}

    ${parts.aspects or ""}

    ${parts.profiles or ""}

    ${parts.hosts or ""}

    ## Usage

    ### Regenerate flake.nix

    This project uses [flake-file](https://github.com/vic/flake-file) for modular flake management:

    ```console
    $ nix run .#write-flake
    ```

    ### Update dependencies

    ```console
    $ nix flake update
    ```

    ### Format code

    ```console
    $ nix fmt
    ```

    ### Generate files

    This README and other generated files are kept in sync with Nix definitions:

    ```console
    $ nix run .#write-files
    ```

    ### Check everything

    ```console
    $ nix flake check
    ```

    ## License

    See [LICENSE](LICENSE) file.
  '';
in
{
  perSystem =
    psArgs@{ pkgs, ... }:
    {
      files.files = [
        {
          path_ = "README.md";
          drv = pkgs.writeText "README.md" readmeContent;
        }
      ];

      # Expose the write-files script as a package
      packages.write-files = psArgs.config.files.writer.drv;
    };
}
