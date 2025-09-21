- Never modify `flake.nix` directly. It is auto-generated from the `flake-file` system:

> flake-file lets you make your `flake.nix` dynamic and modular. Instead of maintaining a single, monolithic `flake.nix`, you define your flake inputs in separate modules _close_ to where their inputs are used. flake-file then automatically generates a clean, up-to-date `flake.nix` for you.
>
> - Keep your flake modular: Manage flake inputs just like the rest of your Nix configuration.
> - Automatic updates: Regenerate your `flake.nix` with a single command (`nix run ".#write-flake"`) whenever your options change.
> - Flake as dependency manifest: Use `flake.nix` only for declaring dependencies, not for complex Nix code.

- All nix files insde the `modules` directory are recursively imported using `import-tree` and output automatically.

- During flake evals, if `tree-fmt` continues to complain about the flake.lock or flake.nix, try `nix run ".#write-flake"`
