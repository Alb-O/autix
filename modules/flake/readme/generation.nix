{ config, ... }:
let
  inherit (config.text.readme) parts;

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

    ### git-sparta Integration

    Autix ships the local [`git-sparta`](git-sparta/README.md) tool for attribute-driven sparse
    workflows. Helpful entry points:

    - `nix run .#git-sparta -- --help` or `just sparta-run -- --help` for command discovery.
    - `just sparta-tags tag=<name>` launches the interactive tag browser (add `repo=<path>` to scan another checkout, `yes=true` to bypass the TUI, and `theme=<name>` to pick a theme).
    - `just sparta-setup` and `just sparta-teardown` wrap the submodule lifecycle commands.
    - Git aliases (`git sparta`, `git sparta-tags`, etc.) forward directly to the packaged binary.

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
      packages.write-files = psArgs.config.files.writer.drv;
    };
}
