  # Autix

  A modular NixOS and Home Manager configuration using the aspect system.

  ## Project Structure

```
modules/
├── aspects/
│   ├── hosts/
│   ├── hosts.nix
│   ├── shared/
│   └── users/
├── den/
│   ├── home-config.nix
│   ├── homes.nix
│   └── hosts.nix
├── flake/
│   ├── core.nix
│   ├── formatter.nix
│   ├── readme/
│   └── upstreams.nix
├── hm/
│   ├── ast-grep/        # Fast and polyglot tool for code searching, linting, rewriting at large scale
│   ├── blender/         # Helper script for Blender daily builds.
│   ├── clipboard/       # Wayland clipboard manager service.
│   ├── codex/           # Codex CLI tooling.
│   ├── env/
│   ├── firefox/         # Firefox config, including policies, profiles and NUR overlay extensions.
│   ├── formatter/       # Formatter definitions and helper packages.
│   ├── fzf/             # Configure fzf with custom defaults.
│   ├── gemini/          # Google Gemini CLI.
│   ├── git/             # Git configuration with helpful defaults.
│   ├── git-sparta/      # git-sparta CLI integration for git attribute sparse workflows & tagging.
│   ├── hydrus/          # Hydrus client launcher with Wayland-friendly defaults.
│   ├── kakoune/         # Kakoune editor configuration and plugins.
│   ├── kitty/           # Kitty terminal with themed configuration.
│   ├── lazygit/         # Lazygit configuration.
│   ├── lsp/             # Shared Language Server Protocol tooling.
│   ├── mako/            # Mako notification daemon for graphical profiles.
│   ├── mcp/             # MCP Servers configuration.
│   ├── mpv/             # MPV media player defaults.
│   ├── nh/              # Utility script collection for nohup helper (nh).
│   ├── nushell/         # Nushell - A new type of shell.
│   ├── opencode/        # OpenCode configuration.
│   ├── polkit/          # Polkit agent for graphical sessions.
│   ├── sillytavern/     # SillyTavern launcher and desktop entry.
│   ├── tmux/            # Tmux, primarily for agents interactive usage.
│   ├── vscode/          # Visual Studio Code (unfree) enablement.
│   ├── xdg/             # XDG base directory layout and session tweaks.
│   ├── yazi/            # Setup Yazi terminal file manager.
│   ├── youtube-music/   # Electron wrapper around YouTube Music
│   ├── zk/              # Zettelkasten CLI (zk) configuration.
│   └── zoxide/          # Enable zoxide jump navigation.
└── sys/
    ├── cli/             # Common CLI tooling bundle.
    ├── essential/       # Baseline essential packages for all profiles and hosts.
    ├── fonts/           # Shared font bundle and defaults.
    ├── gdm/             # GNOME Display Manager.
    ├── gnome-services/  # GNOME keyring and supporting services.
    ├── graphical/       # Graphical desktop utilities bundle.
    ├── keyboard/        # Swap Caps Lock and Escape via keyd.
    ├── netshare/        # NFS/CIFS client tooling.
    ├── networking/      # Networking defaults for NetworkManager.
    ├── niri/            # Niri Wayland compositor and related tooling.
    ├── nix-settings/    # Shared Nix daemon and nixpkgs defaults.
    ├── shell-init/      # Ensure login shells hand over to fish with XDG-aware history.
    ├── sops-nix/        # Atomic secret provisioning for NixOS based on sops.
    ├── ssh/             # SSH client defaults and server hardening.
    ├── tty/             # kmscon font defaults for virtual consoles.
    ├── wayland/         # Wayland-first session defaults.
    └── wsl/             # NixOS-WSL integration for Windows Subsystem for Linux.
```

Files/directories prefixed with `_` or `.` are ignored by auto-import.
All `.nix` files in `modules/` are automatically imported as flake-parts modules.


  ## Aspects

Autix uses `flake.aspects` for all dendritic composition. Each aspect represents a logical
unit of functionality that can target specific hosts or users.

### Aspect Details

| Aspect | Description | Scopes |
|--------|-------------|--------|
| `albert` | Base user configuration for Albert O'Shea. | homeManager, name, nixos |
| `ast-grep` | Fast and polyglot tool for code searching, linting, rewriting at large scale | homeManager, name |
| `blender` | Helper script for Blender daily builds. | homeManager, name |
| `cli` | Common CLI tooling bundle. | homeManager, name |
| `clipboard` | Wayland clipboard manager service. | homeManager, name |
| `codex` | Codex CLI tooling. | homeManager, name |
| `default` | — | home, host, user |
| `essential` | Baseline essential packages for all profiles and hosts. | homeManager, name, nixos |
| `firefox` | Firefox config, including policies, profiles and NUR overlay extensions. | homeManager, name, overlays |
| `fonts` | Shared font bundle and defaults. | homeManager, name, nixos |
| `formatter` | Formatter definitions and helper packages. | homeManager, name |
| `fzf` | Configure fzf with custom defaults. | homeManager, name |
| `gdm` | GNOME Display Manager. | name, nixos |
| `gemini` | Google Gemini CLI. | homeManager, name |
| `git` | Git configuration with helpful defaults. | homeManager, name |
| `git-sparta` | git-sparta CLI integration for git attribute sparse workflows & tagging. | homeManager, name |
| `gnome-services` | GNOME keyring and supporting services. | name, nixos |
| `graphical` | Graphical desktop utilities bundle. | homeManager, name |
| `host-desktop` | Aspect tree for the primary desktop host. | name, nixos |
| `host-wsl` | Aspect tree for the WSL-based environment. | name, nixos |
| `hydrus` | Hydrus client launcher with Wayland-friendly defaults. | homeManager, name |
| `kakoune` | Kakoune editor configuration and plugins. | homeManager, name |
| `keyboard` | Swap Caps Lock and Escape via keyd. | name, nixos |
| `kitty` | Kitty terminal with themed configuration. | homeManager, name |
| `lazygit` | Lazygit configuration. | homeManager, name |
| `lsp` | Shared Language Server Protocol tooling. | homeManager, name |
| `mako` | Mako notification daemon for graphical profiles. | homeManager, name |
| `mcp` | MCP Servers configuration. | homeManager, name, overlays |
| `mpv` | MPV media player defaults. | homeManager, name |
| `netshare` | NFS/CIFS client tooling. | name, nixos |
| `networking` | Networking defaults for NetworkManager. | homeManager, name, nixos |
| `nh` | Utility script collection for nohup helper (nh). | homeManager, name |
| `niri` | Niri Wayland compositor and related tooling. | homeManager, name, nixos, overlays |
| `nix-settings` | Shared Nix daemon and nixpkgs defaults. | name, nixos |
| `nushell` | Nushell - A new type of shell. | homeManager, name |
| `opencode` | OpenCode configuration. | homeManager, name |
| `polkit` | Polkit agent for graphical sessions. | homeManager, name |
| `shell-init` | Ensure login shells hand over to fish with XDG-aware history. | name, nixos |
| `sillytavern` | SillyTavern launcher and desktop entry. | homeManager, name |
| `sops-nix` | Atomic secret provisioning for NixOS based on sops. | homeManager, name, nixos, overlays |
| `ssh` | SSH client defaults and server hardening. | homeManager, name, nixos |
| `state-version` | Shared stateVersion policy. | homeManager, name, nixos |
| `tmux` | Tmux, primarily for agents interactive usage. | homeManager, name |
| `tty` | kmscon font defaults for virtual consoles. | name, nixos |
| `vscode` | Visual Studio Code (unfree) enablement. | homeManager, name |
| `wayland` | Wayland-first session defaults. | homeManager, name, nixos |
| `workspace` | Session environment defaults for shells and direnv. | homeManager, name |
| `wsl` | NixOS-WSL integration for Windows Subsystem for Linux. | homeManager, name, nixos |
| `xdg` | XDG base directory layout and session tweaks. | homeManager, name |
| `yazi` | Setup Yazi terminal file manager. | homeManager, name |
| `youtube-music` | Electron wrapper around YouTube Music | homeManager, name |
| `zk` | Zettelkasten CLI (zk) configuration. | homeManager, name |
| `zoxide` | Enable zoxide jump navigation. | homeManager, name |

Aspects are defined in `modules/aspects/**`. Each aspect can contribute modules for any
dendritic class (`nixos`, `homeManager`, etc.) and declare dependencies through `includes`.


  ## Hosts & Homes via den

Host and user bindings are declared with [`den`](https://github.com/vic/den).
Each host entry references the aspect tree that should be composed for the
operating system and its users.

Active hosts:
- **desktop** (x86_64-linux) — aspect `host-desktop`
- **wsl** (x86_64-linux) — aspect `host-wsl`

Build a host configuration:
```console
$ nixos-rebuild switch --flake .#<hostname>
```

Standalone homes can be registered in `den.homes` when needed.


## Aspect Topology

The dendritic graph is orchestrated with `flake.aspects`. Host aspects stitch
together system modules, while user aspects (such as `albert`) pull in
Home Manager features.

See [`modules/aspects/hosts.nix`](modules/aspects/hosts.nix) and
[`modules/aspects/users/albert.nix`](modules/aspects/users/albert.nix) for the
entry points used by `den`.


  ## Usage

  ### Common commands

  ```console
  $ just regen   # Regenerate generated files and format the tree
  $ just check   # Run regen followed by nix flake check --no-update-lock-file
  ```

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
