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

# 3. Prune dangling nvim-treesitter symlinks orphaned by step 2.
#    nvim-treesitter symlinks each language's queries (and sometimes parsers)
#    into $NVIM_DATA/site/{queries,parser}. After removing lazy/, those links
#    point nowhere and silently break highlighting (parser loads, but
#    vim.treesitter.query.get(lang, 'highlights') returns nil).
for sub in queries parser; do
  dir="$NVIM_DATA/site/$sub"
  [ -d "$dir" ] || continue
  while IFS= read -r -d '' link; do
    echo "Removing dangling symlink: ${link#$NVIM_DATA/}"
    rm -f "$link"
  done < <(find "$dir" -maxdepth 1 -type l ! -exec test -e {} \; -print0)
done

# 4. Clear compiled cache (vim.loader rebuilds it on next launch)
if [ -d "$NVIM_CACHE" ]; then
  echo "Clearing nvim cache..."
  rm -rf "$NVIM_CACHE"
fi

echo "Done. vim.pack will reinstall plugins on next nvim launch."
