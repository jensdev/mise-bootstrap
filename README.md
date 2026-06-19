# mise-bootstrap

Declarative machine setup for Fedora using [mise](https://mise.jdx.dev/bootstrap.html).

## What gets installed

### System Packages (DNF)

Development tools, CLI utilities, repositories, and applications:

| Tool / Group | Description |
|------|-------------|
| `eza` | Modern `ls` replacement with icons |
| `zoxide` | Smarter `cd` |
| `starship` | Cross-shell prompt |
| `fzf` | Fuzzy finder |
| `bat` | `cat` with syntax highlighting |
| `ripgrep`, `fd-find` | Fast grep / find replacements |
| `neovim` | Vim-fork focused on extensibility |
| `chromium`, `google-chrome-stable` | Browsers |
| `code` | Visual Studio Code editor |
| `docker-ce`, `docker-ce-cli`, etc. | Docker container runtime and tools |
| `ghostty` | Highly performant GPU-accelerated terminal emulator |
| `fastfetch`, `tmux`, `htop`, `jq`, `tree`, `vim` | CLI essentials |
| `@virtualization` | Virtualization stack (qemu, libvirt, etc.) |
| `@development-tools` | Compilers, make, etc. |

### Dev Tools (mise)

| Tool | Version |
|------|---------|
| Node.js | LTS |
| Bun | latest |
| Java | 17 |
| Swift | latest |
| ast-grep | latest |

### Dotfiles

Symlinked/configured:

- `.config/fish/config.fish` — fish shell configuration with path, aliases, and tool integrations
- `.gitconfig` — Git configuration
- `.config/starship.toml` — Starship prompt theme

### Shell

- Login shell set to `/usr/bin/fish`
- [Starship](https://starship.rs/) prompt, zoxide, fzf, and mise integrations.
- Pure Fish configuration with no heavy plugin frameworks required (Fish features built-in autosuggestions and syntax highlighting).

## Bootstrap a fresh Fedora machine

```bash
# 1. Install mise
curl https://mise.run | sh

# 2. Activate mise in current shell
eval "$(~/.local/bin/mise activate bash)"

# 3. Clone this repo
git clone https://github.com/jensdev/mise-bootstrap.git
cd mise-bootstrap

# 4. Run bootstrap
mise bootstrap
```

That's it. `mise bootstrap` will:

1. Run the `pre-packages` hook (`setup-repos.sh`) to configure external repositories (RPM Fusion, VS Code, Docker, Chrome, and COPR).
2. Install all system packages via `dnf` (including browsers, virtualization, Docker, and utilities).
3. Symlink dotfiles to `~`.
4. Set login shell to `/usr/bin/fish`.
5. Install dev tools (Node.js, Bun, Java, Swift, ast-grep).
6. Run the `bootstrap` task (`post-bootstrap.sh`) to:
   - Install Nerd Fonts.
   - Install and symlink Android Studio.
   - Enable and start `libvirtd` and `docker` services.
   - Set up user group memberships (`docker`, `libvirt`, `kvm`).
   - Configure Flatpak and install applications (Slack, Spotify, Insomnia, Podman Desktop, Gearlever).

Log out and back in (or run `fish`) to start using your new shell.

## Customizing

- **Add packages**: Edit `[bootstrap.packages]` in `mise.toml`
- **Add dotfiles**: Place files in `dotfiles/` and add entries to `[system.files]`
- **Add dev tools**: Edit `[tools]` in `mise.toml`
- **Re-run**: `mise bootstrap` is idempotent — safe to run again
