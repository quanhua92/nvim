#!/bin/bash
# Clean up stale Neovim data (lazy.nvim plugins, cache).
# Safe to run after migrating to vim.pack.
# Mason tools (~/.local/share/nvim/mason) are kept — still in use.

set -euo pipefail

NVIM_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

# 1. Bail if nvim is running
if pgrep -x nvim >/dev/null 2>&1; then
  echo "ERROR: nvim is running. Close all instances first." >&2
  exit 1
fi

# 2. Remove stale lazy.nvim plugins
if [ -d "$NVIM_DATA/lazy" ]; then
  echo "Removing lazy.nvim plugins..."
  rm -rf "$NVIM_DATA/lazy"
fi

# 3. Clear compiled cache (vim.loader rebuilds it on next launch)
if [ -d "$NVIM_CACHE" ]; then
  echo "Clearing nvim cache..."
  rm -rf "$NVIM_CACHE"
fi

echo "Done. vim.pack will reinstall plugins on next nvim launch."
