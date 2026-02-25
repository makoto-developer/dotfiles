# dotfiles

macOS development environment configuration files

---

## ✨ Features

- 🐟 **Fish shell** configuration with useful aliases
- 🎨 **Neovim** with LSP, plugins, and modern development tools
- 💻 **VSCode** Vim mode configuration
- 📝 **Git** configuration with delta diff viewer
- 🔧 **Version management** with mise/asdf
- 🚀 **One-command setup** with automated installation script

---

## 🚀 Quick Start

### 1. Clone this repository

```bash
# Using ghq (recommended)
ghq get https://github.com/makoto-developer/dotfiles.git
ln -s ~/work/repositories/github.com/makoto-developer/dotfiles ~/dotfiles

# Or clone directly
cd ~
git clone git@github.com:makoto-developer/dotfiles.git
```

### 2. Run the installation script

```bash
cd ~/dotfiles
./install.sh
```

The script will guide you through:
- Git configuration setup
- Shell configuration (Fish/Zsh)
- Version manager setup (mise/asdf)
- Vim/Neovim setup
- VSCode setup

### 3. Restart your terminal

```bash
exec $SHELL
```

---

## 📁 Structure

```
dotfiles/
├── README.md                 # This file
├── IMPROVEMENTS.md           # Improvement suggestions
├── install.sh               # Automated setup script ⭐
│
├── git/                     # Git configuration
│   ├── .gitconfig
│   ├── .git_alias
│   ├── .git_core
│   ├── .git_delta
│   └── .gitignore_global
│
├── fish/                    # Fish shell configuration
│   ├── config.fish
│   ├── init.fish
│   └── conf.d/              # Modular configurations
│       ├── alias.fish
│       ├── env.fish
│       ├── git.fish
│       └── ...
│
├── vim/                     # Vim/Neovim configuration
│   ├── README.md            # Vim setup guide
│   ├── .vimrc               # Standard Vim
│   ├── .ideavimrc           # JetBrains IDEs
│   ├── config/              # Vim configuration modules
│   └── nvim/                # Neovim with plugins
│       ├── README.md
│       ├── RECOMMENDATIONS.md
│       ├── setup.sh         # Neovim setup script
│       ├── init.vim
│       ├── dein.toml        # Plugin definitions
│       └── coc-settings.json
│
├── vscode/                  # VSCode configuration
│   ├── README.md
│   ├── SETUP.md             # Multi-machine sync guide
│   ├── setup.sh             # VSCode setup script
│   ├── settings.json        # VSCode settings
│   └── extensions.txt       # Extension list
│
├── zsh/                     # Zsh configuration (optional)
│   ├── .zshrc
│   └── ...
│
└── asdf/                    # Version manager
    └── .tool-versions       # Language versions
```

---

## 📦 Prerequisites

### Required

- **macOS** (tested on macOS 14+)
- **Git** (pre-installed on macOS)
- **Homebrew** (package manager)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Recommended

```bash
# Essential tools
brew install fish neovim git-delta mise

# Optional but useful
brew install ripgrep fzf bat eza ghq

# VSCode
brew install --cask visual-studio-code
```

---

## ⚙️ Manual Setup

If you prefer manual setup instead of using `install.sh`:

### Git Configuration

First, create personal git config files:

**~/.git_user:**
```
[user]
name = Your Name
email = your.email@example.com
```

**~/.git_github:**
```
[github]
user = "your-github-username"
```

**~/.git_globalignore:**
```
[core]
excludesFile = /Users/yourname/.git_globalignore
```

Then link the configuration files:

```bash
cd ~/dotfiles
ln -sf $PWD/git/.gitconfig ~/.gitconfig
ln -sf $PWD/git/.git_alias ~/.git_alias
ln -sf $PWD/git/.git_core ~/.git_core
ln -sf $PWD/git/.git_delta ~/.git_delta
ln -sf $PWD/git/.gitignore_global ~/.gitignore_global
```

### Fish Shell

```bash
ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/fish/init.fish ~/.config/omf/init.fish
ln -sf ~/dotfiles/fish/conf.d ~/.config/fish/conf.d
```

### Version Manager

**mise:**
```bash
ln -s ~/dotfiles/mise ~/.config/
```

**asdf (if you prefer asdf over mise):**
```bash
ln -sf ~/dotfiles/asdf/.tool-versions ~/.tool-versions
```

### Vim/Neovim

See [vim/README.md](./vim/README.md) for detailed setup instructions.

Quick setup:
```bash
cd ~/dotfiles/vim/nvim
./setup.sh
```

### VSCode

See [vscode/SETUP.md](./vscode/SETUP.md) for multi-machine setup guide.

Quick setup:
```bash
cd ~/dotfiles/vscode
./setup.sh
```

---

## 🔄 Syncing Across Multiple Machines

### Setting up a new machine

```bash
# 1. Clone dotfiles
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles

# 2. Run install script
cd ~/dotfiles
./install.sh

# 3. Done! All configurations are symlinked
```

### Updating configuration

**On machine A (after making changes):**
```bash
cd ~/dotfiles
git add .
git commit -m "Update configuration"
git push
```

**On machine B (to sync changes):**
```bash
cd ~/dotfiles
git pull
# Changes are automatically reflected via symlinks
```

---

## 🎯 Key Features

### Fish Shell Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `vi` | `nvim` | Use Neovim |
| `l` | `ls -ltraG` | List files, newest last |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `g` | `git` | Git shortcut |
| `clip` | `pbcopy` | Copy to clipboard |
| `pwgen` | Password generator | Generate secure password |

See [fish/conf.d/alias.fish](./fish/conf.d/alias.fish) for complete list.

### Git Configuration

- 📊 **Delta** - Beautiful diffs with syntax highlighting
- 🎨 **Aliases** - Convenient git shortcuts
- 🔒 **Global ignore** - Ignore common system files
- 🚀 **Auto setup remote** - Automatically set upstream on push

### Neovim Features

- 🔌 **LSP integration** via CoC
- 🎨 **Syntax highlighting** with Treesitter
- 📝 **Auto-completion**
- 🔍 **Fuzzy finding** with fzf
- 📊 **Git integration** with vim-fugitive
- 🎨 **Beautiful theme** (Gruvbox)

See [vim/nvim/RECOMMENDATIONS.md](./vim/nvim/RECOMMENDATIONS.md) for details.

### VSCode Configuration

- ⌨️ **Vim mode** with custom keybindings
- 📋 **Clipboard integration** - `y` yanks to system clipboard
- 🎨 **Consistent settings** across machines
- 🔧 **Language-specific** configurations

See [vscode/README.md](./vscode/README.md) for details.

---

## 🐛 Troubleshooting

### Symlinks not working

```bash
# Check if symlink exists
ls -la ~/.gitconfig

# If broken, remove and recreate
unlink ~/.gitconfig
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
```

### Git config not found

Make sure you've created personal config files:
- `~/.git_user`
- `~/.git_github`
- `~/.git_globalignore`

See the [Git Configuration](#git-configuration) section above.

### Neovim plugins not loading

```bash
# Reinstall plugins
nvim
:call dein#clear_state()
:call dein#install()

# Check health
:checkhealth
```

### VSCode settings not syncing

```bash
# On macOS
ls -la ~/Library/Application\ Support/Code/User/settings.json

# Should show symlink to dotfiles/vscode/settings.json
# If not, run setup again
cd ~/dotfiles/vscode
./setup.sh
```

---

## 📚 Documentation

- [IMPROVEMENTS.md](./IMPROVEMENTS.md) - Improvement suggestions and best practices
- [vim/README.md](./vim/README.md) - Vim/Neovim setup guide
- [vim/nvim/RECOMMENDATIONS.md](./vim/nvim/RECOMMENDATIONS.md) - Plugin recommendations
- [vscode/README.md](./vscode/README.md) - VSCode setup guide
- [vscode/SETUP.md](./vscode/SETUP.md) - Multi-machine setup guide

---

## 💡 Tips

### Safely removing symlinks

Use `unlink` instead of `rm` to avoid deleting the source files:

```bash
# ✅ Good
unlink ~/.gitconfig

# ❌ Bad - might delete source file
rm ~/.gitconfig
```

### Update all tools

```bash
# Update Homebrew packages
brew update && brew upgrade && brew cleanup

# Update Neovim plugins
nvim --headless "+call dein#update()" +qa

# Update mise/asdf tools
mise upgrade
# or
asdf plugin update --all
```

### Backup before changes

```bash
# The install script automatically creates backups
# But you can manually backup:
cp ~/.gitconfig ~/.gitconfig.backup.$(date +%Y%m%d)
```

---

## 🤝 Contributing

Improvements and suggestions are welcome! See [IMPROVEMENTS.md](./IMPROVEMENTS.md) for current improvement proposals.

---

## 📄 License

MIT License - feel free to use and modify

---

## 🔗 Related Resources

- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
- [GitHub does dotfiles](https://dotfiles.github.io/)
- [Fish shell documentation](https://fishshell.com/docs/current/)
- [Neovim documentation](https://neovim.io/doc/)
- [VSCodeVim](https://github.com/VSCodeVim/Vim)

---

## ⚡ Quick Reference

```bash
# Initial setup
git clone git@github.com:makoto-developer/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh

# Update from remote
cd ~/dotfiles && git pull

# Edit configuration
cd ~/dotfiles
# Make changes to files
git add .
git commit -m "Update config"
git push

# Test setup
cd ~/dotfiles
./test.sh  # (if you create test script)
```

---

**Happy coding! 🚀**
