# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS development environment setup repository that automates the installation and configuration of development tools, applications, and dotfiles. It manages system configuration through Homebrew, shell scripts, and dotfiles.

## Core Architecture

### Installation Flow
1. **install.sh**: Main entry point
   - Installs Homebrew if not present
   - Runs `brew bundle` to install packages from Brewfile
   - Executes all scripts in `scripts/` directory

2. **Brewfile**: Declarative package management
   - Defines all Homebrew packages, casks, and taps
   - Includes CLI tools, development tools, k8s tooling, language servers, and applications

3. **scripts/**: Modular installation scripts
   - Each script handles a specific tool or language (nvim, nvm, rbenv, gcloud-cli, k8s-krew, xcode, elixer)
   - Run individually with `just run <script-name>` or all via `install.sh`

4. **dotfiles/**: Configuration files
   - zshrc: Shell configuration with paths, history settings, aliases, and tool initialization
   - gitconfig: Git configuration with aliases and settings
   - gitmessage: Git commit message template (includes PLATFORM ticket placeholder)

5. **manual_scripts/**: Manual setup tasks
   - publish-gitconfig: Copies dotfiles/gitconfig to ~/.gitconfig
   - iTerm2 preferences (com.googlecode.iterm2.plist)

### Setup Flow

1. User runs `./install.sh` or `just install`
2. Script ensures Homebrew is installed and in PATH
3. `brew bundle` installs all packages from Brewfile
4. All scripts in `scripts/` directory execute in order, setting up tools and creating symlinks
5. Manual post-setup tasks include setting iTerm preferences and adding SSH keys to GitHub

## Common Commands

### Initial Setup
- `./install.sh` - Main installation script that installs Homebrew (if needed), runs `brew bundle`, and executes all scripts in the `scripts/` directory
- `just install` - Alternative way to run the installation (alias for `./install.sh`)

### Package Management
- `brew bundle` - Install/update all packages defined in Brewfile
- `just bundle` - Same as above
- `just fix-brew-lock-conflicts` - Resolve Brewfile.lock.json conflicts by resetting and regenerating the lock file

### Development Tasks
- `just check-scripts` - Run shellcheck on all shell scripts in the `scripts/` directory
- `just run <target-module>` - Execute a specific script from the `scripts/` directory (e.g., `just run nvim.sh`)

### Git Configuration Management
- `manual_scripts/publish-gitconfig` - Copy dotfiles/gitconfig to ~/.gitconfig (overwrites existing global git config)
- `manual_scripts/save-gitconfig` - Save current ~/.gitconfig back to dotfiles/gitconfig for version control


### Issue Tracking with Beads
This repository uses Beads for AI-native issue tracking:
```bash
# Create new issue
bd create "Issue description"

# List all issues
bd list

# View issue details
bd show <issue-id>

# Update issue status
bd update <issue-id> --status in_progress
bd update <issue-id> --status done

# Sync issues with remote
bd sync
```

## Git Workflow

### Custom Commit Aliases
- `gcpl()`: Quick commit with PLATFORM ticket number
  - Usage: `gcpl "commit message" 1234`
  - Generates: `commit message\n\n[PLATFORM-1234]`
- Standard alias: `gcm` = `git commit -m`

### Git Configuration
- Default branch: `main`
- Pull strategy: fast-forward only
- Editor: nvim
- Commit template: Uses dotfiles/gitmessage with PLATFORM ticket placeholder

## Key Development Tools

### Shell Environment (zshrc)
- **z**: Fuzzy directory navigation (loaded from `$(brew --prefix)/etc/profile.d/z.sh`)
- **pure**: Command prompt theme
- **nvm**: Node version manager (loaded from `~/.nvm/nvm.sh`)
- **pyenv**: Python version manager
- **GOPATH**: Set to `$HOME/go`
- **krew**: kubectl plugin manager (added to PATH)
- **gcloud**: Google Cloud SDK with completion

### Installed Tools (Brewfile)
- **Development**: nvim, tmux, git-crypt, just (task runner)
- **Languages**: go, python3, npm, asdf, tfenv
- **k8s**: minikube, kubectl, kubectx, kustomize, helm, k9s, kubectl-argo-rollouts
- **Cloud**: awscli, gcloud-cli, doctl
- **Databases**: mysql, libpq
- **Search/Find**: ripgrep, fd, the_silver_searcher (ag)
- **Utilities**: jq, yq, tree, watch, htop, nmap, certbot
- **Containers**: docker, docker-compose

## Known Issues

### Current Issues (from README)
1. `z` command not found after installation
2. Terminal colors and iTerm dark mode not setting correctly
3. Some casks report "No formula for Apple Silicon" during `brew bundle`

## Important Notes

- Manual setup required for iTerm2 preferences: Load from `manual_scripts/` directory in iTerm2 settings
- Docker must be installed manually from https://docs.docker.com/docker-for-mac/install/
- SSH key setup required before full usage (see README pre-setup steps)
- The dotfiles are not automatically symlinked; gitconfig must be manually published via `manual_scripts/publish-gitconfig`. The claude files are symlinked by ./scripts/claude.sh
