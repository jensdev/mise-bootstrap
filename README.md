# mise-bootstrap

Declarative machine setup for Fedora using [mise](https://mise.jdx.dev/bootstrap.html).

## What gets installed

### System Packages (DNF)

Development tools, CLI utilities, and modern replacements:

| Tool | Description |
|------|-------------|
| `eza` | Modern `ls` replacement with icons |
| `zoxide` | Smarter `cd` |
| `starship` | Cross-shell prompt |
| `fzf` | Fuzzy finder |
| `bat` | `cat` with syntax highlighting |
| `ripgrep` | Fast `grep` |
| `fd-find` | Fast `find` |
| `fastfetch` | System info |
| `tmux`, `htop`, `jq`, `tree`, `vim` | Essentials |
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

Symlinked to `~`:

- `.bashrc` — Fedora default + PATH setup
- `.zshrc` — oh-my-zsh, starship, zoxide, fzf, eza aliases
- `.gitconfig` — Git configuration
- `.config/starship.toml` — Starship prompt theme

### Shell

- Login shell set to `/bin/zsh`
- [oh-my-zsh](https://ohmyz.sh/) with plugins: `git`, `sudo`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `copyfile`, `copybuffer`
- [Starship](https://starship.rs/) prompt (replaces oh-my-zsh themes)

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

1. Install all system packages via `dnf`
2. Symlink dotfiles to `~`
3. Set login shell to `/bin/zsh`
4. Install dev tools (node, bun, java, swift, ast-grep)
5. Install oh-my-zsh + plugins

Log out and back in (or run `zsh`) to start using your new shell.

## Customizing

- **Add packages**: Edit `[bootstrap.packages]` in `mise.toml`
- **Add dotfiles**: Place files in `dotfiles/` and add entries to `[system.files]`
- **Add dev tools**: Edit `[tools]` in `mise.toml`
- **Re-run**: `mise bootstrap` is idempotent — safe to run again
