# Autix

A modular NixOS and Home Manager configuration using the aspect system.

## Project Structure

```
modules/
├── aspect/   # Aspect system core (aggregation, options)
│   ├── aggregate.nix
│   └── options.nix
├── flake/    # Flake-level configuration (formatter, nix config, file generation)
│   ├── core.nix
│   ├── formatter.nix
│   ├── nixconfig.nix
│   └── readme/
├── hm/       # Home Manager aspects and profiles
│   ├── blender/         # Helper script for Blender daily builds.
│   ├── clipboard/       # Wayland clipboard manager service.
│   ├── codex/           # Codex CLI tooling.
│   ├── emacs/           # Emacs editor configured with the emacs-overlay.
│   ├── env/
│   ├── firefox/         # Firefox configuration with policies and profiles.
│   ├── formatter/       # Formatter definitions and helper packages.
│   ├── fzf/             # Configure fzf with custom defaults.
│   ├── gemini/          # Gemini CLI tooling.
│   ├── git/             # Git configuration with helpful defaults.
│   ├── hydrus/          # Hydrus client launcher with Wayland-friendly defaults.
│   ├── kakoune/         # Kakoune editor configuration and plugins.
│   ├── kitty/           # Kitty terminal with themed configuration.
│   ├── lazygit/         # Lazygit configuration.
│   ├── lsp/             # Shared Language Server Protocol tooling.
│   ├── mako/            # Mako notification daemon for graphical profiles.
│   ├── mpv/             # MPV media player defaults.
│   ├── nh/              # Utility script collection for nohup helper (nh).
│   ├── opencode/        # OpenCode configuration.
│   ├── polkit/          # Polkit agent for graphical sessions.
│   ├── sillytavern/     # SillyTavern launcher and desktop entry.
│   ├── vscode/          # Visual Studio Code (unfree) enablement.
│   ├── wsl/             # WSL integration helpers.
│   ├── xdg/             # XDG base directory layout and session tweaks.
│   ├── yazi/            # Setup Yazi terminal file manager.
│   ├── zk/              # Zettelkasten CLI (zk) configuration.
│   └── zoxide/          # Enable zoxide jump navigation.
├── hosts/    # Host definitions and composition
│   ├── compose.nix
│   ├── desktop/
│   ├── options.nix
│   └── wsl/             # WSL integration helpers.
├── profiles/
│   ├── albert/          # Base user configuration for Albert O'Shea.
│   ├── default.nix
│   └── options.nix
└── sys/      # System-level configuration
    ├── cli/             # Common CLI tooling bundle.
    ├── dev/             # Development language servers and toolchain bundle.
    ├── essential/       # Baseline essential packages for all profiles and hosts.
    ├── fonts/           # Shared font bundle and defaults.
    ├── gdm/             # GNOME Display Manager.
    ├── gnome-services/  # GNOME keyring and supporting services.
    ├── graphical/       # Graphical desktop utilities bundle.
    ├── i18n/            # Default locale configuration.
    ├── keyboard/        # Swap Caps Lock and Escape via keyd.
    ├── netshare/        # NFS/CIFS client tooling.
    ├── networking/      # Networking defaults for NetworkManager.
    ├── niri/            # Niri Wayland compositor and related tooling.
    ├── nix-settings/    # Shared Nix daemon and nixpkgs defaults.
    ├── shell-init/      # Ensure login shells hand over to fish with XDG-aware history.
    ├── ssh/             # SSH client defaults and server hardening.
    ├── tty/             # kmscon font defaults for virtual consoles.
    └── wayland/         # Wayland-first session defaults.
```

Files/directories prefixed with `_` or `.` are ignored by auto-import.
All `.nix` files in `modules/` are automatically imported as flake-parts modules.

## Aspects

Autix uses a modular **aspect system** for configuration. Each aspect represents a logical
unit of functionality that can target specific hosts or profiles.

Currently enabled aspects: albert, blender, cli, clipboard, codex, dev, emacs, essential, firefox, fonts, formatter, fzf, gdm, gemini, git, gnome-services, graphical, hydrus, i18n, kakoune, keyboard, kitty, lazygit, lsp, mako, mpv, netshare, networking, nh, niri, nix-settings, opencode, polkit, shell-init, sillytavern, ssh, tty, vscode, wayland, workspace, wsl, xdg, yazi, zk, zoxide

### Aspect Details

| Aspect           | Description                                                   | Scopes      |
| ---------------- | ------------------------------------------------------------- | ----------- |
| `albert`         | Base user configuration for Albert O'Shea.                    | NixOS, Home |
| `blender`        | Helper script for Blender daily builds.                       | Home        |
| `cli`            | Common CLI tooling bundle.                                    | Home        |
| `clipboard`      | Wayland clipboard manager service.                            | Home        |
| `codex`          | Codex CLI tooling.                                            | Home        |
| `dev`            | Development language servers and toolchain bundle.            | Home        |
| `emacs`          | Emacs editor configured with the emacs-overlay.               | Home        |
| `essential`      | Baseline essential packages for all profiles and hosts.       | NixOS, Home |
| `firefox`        | Firefox configuration with policies and profiles.             | Home        |
| `fonts`          | Shared font bundle and defaults.                              | NixOS, Home |
| `formatter`      | Formatter definitions and helper packages.                    | Home        |
| `fzf`            | Configure fzf with custom defaults.                           | Home        |
| `gdm`            | GNOME Display Manager.                                        | NixOS       |
| `gemini`         | Gemini CLI tooling.                                           | Home        |
| `git`            | Git configuration with helpful defaults.                      | Home        |
| `gnome-services` | GNOME keyring and supporting services.                        | NixOS       |
| `graphical`      | Graphical desktop utilities bundle.                           | Home        |
| `hydrus`         | Hydrus client launcher with Wayland-friendly defaults.        | Home        |
| `i18n`           | Default locale configuration.                                 | NixOS       |
| `kakoune`        | Kakoune editor configuration and plugins.                     | Home        |
| `keyboard`       | Swap Caps Lock and Escape via keyd.                           | NixOS       |
| `kitty`          | Kitty terminal with themed configuration.                     | Home        |
| `lazygit`        | Lazygit configuration.                                        | Home        |
| `lsp`            | Shared Language Server Protocol tooling.                      | Home        |
| `mako`           | Mako notification daemon for graphical profiles.              | Home        |
| `mpv`            | MPV media player defaults.                                    | Home        |
| `netshare`       | NFS/CIFS client tooling.                                      | NixOS       |
| `networking`     | Networking defaults for NetworkManager.                       | NixOS, Home |
| `nh`             | Utility script collection for nohup helper (nh).              | Home        |
| `niri`           | Niri Wayland compositor and related tooling.                  | NixOS, Home |
| `nix-settings`   | Shared Nix daemon and nixpkgs defaults.                       | NixOS       |
| `opencode`       | OpenCode configuration.                                       | Home        |
| `polkit`         | Polkit agent for graphical sessions.                          | Home        |
| `shell-init`     | Ensure login shells hand over to fish with XDG-aware history. | NixOS       |
| `sillytavern`    | SillyTavern launcher and desktop entry.                       | Home        |
| `ssh`            | SSH client defaults and server hardening.                     | NixOS, Home |
| `tty`            | kmscon font defaults for virtual consoles.                    | NixOS       |
| `vscode`         | Visual Studio Code (unfree) enablement.                       | Home        |
| `wayland`        | Wayland-first session defaults.                               | NixOS, Home |
| `workspace`      | Session environment defaults for shells and direnv.           | Home        |
| `wsl`            | WSL integration helpers.                                      | Home        |
| `xdg`            | XDG base directory layout and session tweaks.                 | Home        |
| `yazi`           | Setup Yazi terminal file manager.                             | Home        |
| `zk`             | Zettelkasten CLI (zk) configuration.                          | Home        |
| `zoxide`         | Enable zoxide jump navigation.                                | Home        |

Aspects are defined in `modules/` directories and automatically aggregated by the build system.
Each aspect can contribute:

- Modules for NixOS or Home Manager
- Overlays for package customization
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

## License

See [LICENSE](LICENSE) file.
