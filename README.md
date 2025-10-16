# Autix

A modular NixOS and Home Manager configuration using the aspect system.

## Project Structure

```
modules/
├── aspect/
│   ├── aggregate.nix
│   └── options.nix
├── flake/
│   ├── core.nix
│   ├── formatter.nix
│   ├── nixconfig.nix
│   └── readme/
├── hm/
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
│   ├── mpv/             # MPV media player defaults.
│   ├── nh/              # Utility script collection for nohup helper (nh).
│   ├── nushell/         # Nushell - A new type of shell.
│   ├── opencode/        # OpenCode configuration.
│   ├── polkit/          # Polkit agent for graphical sessions.
│   ├── sillytavern/     # SillyTavern launcher and desktop entry.
│   ├── vscode/          # Visual Studio Code (unfree) enablement.
│   ├── xdg/             # XDG base directory layout and session tweaks.
│   ├── yazi/            # Setup Yazi terminal file manager.
│   ├── youtube-music/   # Electron wrapper around YouTube Music
│   ├── zk/              # Zettelkasten CLI (zk) configuration.
│   └── zoxide/          # Enable zoxide jump navigation.
├── hosts/
│   ├── compose.nix
│   ├── desktop/
│   ├── options.nix
│   └── wsl/             # NixOS-WSL integration for Windows Subsystem for Linux.
├── profiles/
│   ├── albert/          # Base user configuration for Albert O'Shea.
│   ├── default.nix
│   └── options.nix
└── sys/
    ├── cli/             # Common CLI tooling bundle.
    ├── dev/             # Development language servers and toolchain bundle.
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
    ├── sops-nix/        # Atomic secret provisioning for NixOS with shared secret helper.
    ├── ssh/             # SSH client defaults and server hardening.
    ├── tty/             # kmscon font defaults for virtual consoles.
    ├── wayland/         # Wayland-first session defaults.
    └── wsl/             # NixOS-WSL integration for Windows Subsystem for Linux.
```

Files/directories prefixed with `_` or `.` are ignored by auto-import.
All `.nix` files in `modules/` are automatically imported as flake-parts modules.

## Aspects

Autix uses a modular **aspect system** for configuration. Each aspect represents a logical
unit of functionality that can target specific hosts or profiles.

### Aspect Details

| Aspect           | Description                                                              | Scopes      |
| ---------------- | ------------------------------------------------------------------------ | ----------- |
| `albert`         | Base user configuration for Albert O'Shea.                               | NixOS, Home |
| `blender`        | Helper script for Blender daily builds.                                  | Home        |
| `cli`            | Common CLI tooling bundle.                                               | Home        |
| `clipboard`      | Wayland clipboard manager service.                                       | Home        |
| `codex`          | Codex CLI tooling.                                                       | Home        |
| `dev`            | Development language servers and toolchain bundle.                       | Home        |
| `essential`      | Baseline essential packages for all profiles and hosts.                  | NixOS, Home |
| `firefox`        | Firefox config, including policies, profiles and NUR overlay extensions. | Home        |
| `fonts`          | Shared font bundle and defaults.                                         | NixOS, Home |
| `formatter`      | Formatter definitions and helper packages.                               | Home        |
| `fzf`            | Configure fzf with custom defaults.                                      | Home        |
| `gdm`            | GNOME Display Manager.                                                   | NixOS       |
| `gemini`         | Google Gemini CLI.                                                       | Home        |
| `git`            | Git configuration with helpful defaults.                                 | NixOS, Home |
| `git-sparta`     | git-sparta CLI integration for git attribute sparse workflows & tagging. | Home        |
| `gnome-services` | GNOME keyring and supporting services.                                   | NixOS       |
| `graphical`      | Graphical desktop utilities bundle.                                      | Home        |
| `hydrus`         | Hydrus client launcher with Wayland-friendly defaults.                   | Home        |
| `kakoune`        | Kakoune editor configuration and plugins.                                | Home        |
| `keyboard`       | Swap Caps Lock and Escape via keyd.                                      | NixOS       |
| `kitty`          | Kitty terminal with themed configuration.                                | Home        |
| `lazygit`        | Lazygit configuration.                                                   | Home        |
| `lsp`            | Shared Language Server Protocol tooling.                                 | Home        |
| `mako`           | Mako notification daemon for graphical profiles.                         | Home        |
| `mpv`            | MPV media player defaults.                                               | Home        |
| `netshare`       | NFS/CIFS client tooling.                                                 | NixOS       |
| `networking`     | Networking defaults for NetworkManager.                                  | NixOS, Home |
| `nh`             | Utility script collection for nohup helper (nh).                         | Home        |
| `niri`           | Niri Wayland compositor and related tooling.                             | NixOS, Home |
| `nix-settings`   | Shared Nix daemon and nixpkgs defaults.                                  | NixOS       |
| `nushell`        | Nushell - A new type of shell.                                           | Home        |
| `opencode`       | OpenCode configuration.                                                  | Home        |
| `polkit`         | Polkit agent for graphical sessions.                                     | Home        |
| `shell-init`     | Ensure login shells hand over to fish with XDG-aware history.            | NixOS       |
| `sillytavern`    | SillyTavern launcher and desktop entry.                                  | Home        |
| `sops-nix`       | Atomic secret provisioning for NixOS with shared secret helper.          | NixOS, Home |
| `ssh`            | SSH client defaults and server hardening.                                | NixOS, Home |
| `tty`            | kmscon font defaults for virtual consoles.                               | NixOS       |
| `vscode`         | Visual Studio Code (unfree) enablement.                                  | Home        |
| `wayland`        | Wayland-first session defaults.                                          | NixOS, Home |
| `workspace`      | Session environment defaults for shells and direnv.                      | Home        |
| `wsl`            | NixOS-WSL integration for Windows Subsystem for Linux.                   | NixOS, Home |
| `xdg`            | XDG base directory layout and session tweaks.                            | Home        |
| `yazi`           | Setup Yazi terminal file manager.                                        | Home        |
| `youtube-music`  | Electron wrapper around YouTube Music                                    | Home        |
| `zk`             | Zettelkasten CLI (zk) configuration.                                     | Home        |
| `zoxide`         | Enable zoxide jump navigation.                                           | Home        |

Aspects are defined in `modules/` directories and automatically aggregated by the build system.
Each aspect can contribute:

- Modules for NixOS or Home Manager
- Overlays for package customization

### sops-nix shared secret helper

The `autix.sops-nix.sharedSecrets` option provisions reusable SOPS entries and filesystem
permissions for both NixOS and Home Manager consumers. Secret identifiers support hierarchical
paths – for example `"git/gitea/credentials"` – and defaults are derived automatically:

- `sops.secrets` key defaults to the identifier (e.g. `git/gitea/credentials`).
- The decrypted file path defaults to `/run/secrets/<slug>` on NixOS and to
  `${XDG_STATE_HOME:-~/.local/state}/autix/secrets/<slug>` in Home Manager, where `<slug>`
  replaces forward slashes and spaces with hyphens.
- On NixOS the reader group defaults to the same slug and will be populated with matching Home
  Manager users unless explicitly disabled. Home Manager secrets omit group management because
  the upstream module does not support it.

```nix
autix.sops-nix.sharedSecrets."git/gitea/credentials" = {
  mode = "0660";
  extraGroupMembers = [ "git" ];
};
```

Consumers can reference `config.autix.sops-nix.sharedSecrets."<identifier>"` to reuse the
derived defaults (such as the decrypted path or provisioned group) without recomputing them.

Override any of the defaults by setting the corresponding option (`path`, `group`, `sopsKey`, etc.).
- Unfree package permissions
- Binary cache substituters and keys

See [`modules/aspect/options.nix`](modules/aspect/options.nix) for the full aspect schema.

## Home Manager Profiles

Profiles define Home Manager configurations. Each profile specifies:

- User account
- System architecture
- Additional custom modules

Available profiles:

- **albert-desktop**: User `albert`
- **albert-wsl**: User `albert`

Build a profile:

```console
$ nix build .#homeConfigurations.<profile>.activationPackage
```

See [`modules/hm/+profiles/options.nix`](modules/hm/+profiles/options.nix) for profile options.

## NixOS Hosts

Host configurations for NixOS systems:

- **desktop**: x86_64-linux, profile: `albert-desktop`
- **wsl**: x86_64-linux, profile: `albert-wsl`

Build a host configuration:

```console
$ nixos-rebuild switch --flake .#<hostname>
```

See [`modules/sys/hosts/options.nix`](modules/sys/hosts/options.nix) for host options.

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
