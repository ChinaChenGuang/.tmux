# Gemini Configuration Log

## 2026-01-04

### Lazygit Installation
- **Status**: Installed manually (binary).
- **Version**: 0.58.0
- **Path**: `/usr/local/bin/lazygit`
- **Reason**: Switched from Snap to manual binary to resolve strict confinement issues with hidden directories (e.g., `~/.tmux`).
- **Tmux Binding**: `Prefix + g` (opens Lazygit in a popup).

### Ranger Configuration
- **Status**: Configured.
- **Config File**: `~/.config/ranger/rc.conf` (generated defaults + custom bindings).
- **Keybindings (Emacs-style)**:
  - `C-n`: Move Down
  - `C-p`: Move Up
  - `C-f`: Enter Directory (Right)
  - `C-b`: Go to Parent Directory (Left)
  - `C-v`: Page Down
  - `M-v`: Page Up
  - `C-s`: Incremental Search
  - `C-g`: Abort

### Tmux Configuration
- Added popup bindings for:
  - `Lazygit` (g)
  - `Ranger` (f)
  - `Neovim` (e)
  - `Config Edit` (C)

## 2026-01-04 (Update 2)
- **Fix**: Resolved `lazygit` permission denied error by restoring ownership of `~/.tmux` to user.
- **Change**: Resolved keybinding conflict for Ranger.
  - Old: `Prefix + f` (Conflicted with `Prefix + C-f` pane nav).
  - New: `Prefix + d` (Matches Emacs `C-x d` Dired convention).
- **Change**: Remapped Detach Client.
  - Old: `Prefix + d`
  - New: `Prefix + C-d`

## 2026-01-05

### Tmux Configuration
- **New Plugin**: `alexwforsythe/tmux-which-key`
- **Purpose**: Provides a popup menu displaying available keybindings, similar to Emacs/Neovim `which-key`.
- **Status**: Installed via TPM.
- **Trigger**: `Prefix + Space` (to avoid conflict with Emacs-style double-prefix).

## 2026-01-09

### Clipboard Synchronization
- **Feature**: Added bi-directional clipboard sync between system (X11/Wayland) and Tmux.
- **Scripts**:
  - `copy_wrapper.sh`: Auto-detects Wayland/X11 for copying.
  - `paste_wrapper.sh`: Auto-detects Wayland/X11 for pasting.
- **Keybindings**:
  - `Prefix + ]`: Paste from system clipboard.
  - Copy mode selections automatically pipe to system clipboard.
- **Offline Installer**: Updated `pack_for_offline.sh` to include `paste_wrapper.sh`.

## 2026-01-09 (Update 2)

### Fix: Tmux Offline Installation
- **Issue**: `tpm` returned error code 1 on offline servers.
- **Cause**: `tmux-which-key` plugin attempted to run a Python build script (`build.py`) which failed due to missing Python/dependencies or version mismatch in the offline environment.
- **Resolution**:
  - Disabled auto-build in `.tmux.conf` using `set -g @tmux-which-key-disable-autobuild 1`.
  - Manually generated `plugins/tmux-which-key/plugin/init.tmux` on the host machine.
  - Repackaged `tmux_offline_installer.tar.gz` to include the pre-compiled `init.tmux` and updated config.