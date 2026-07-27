#!/bin/bash

# --- Configuration ---
MASON_DIR="$HOME/.local/share/nvim/mason"
PACKAGES_DIR="$MASON_DIR/packages"
BIN_DIR="$MASON_DIR/bin"

# List the tools you want to bridge here
# The names must match the package names Mason uses
TARGETS=(
    "stylua"
    "ruff"
    "lua-language-server"
    "rust-analyzer"
    "pyright"
    "clangd"
    "gopls"
    "bash-language-server"
)

echo "🚀 Starting Termux-Mason bridging..."

# Ensure Mason directories exist
mkdir -p "$PACKAGES_DIR"
mkdir -p "$BIN_DIR"

for PKG in "${TARGETS[@]}"; do
    # Find the system binary path
    SYS_BIN=$(command -v "$PKG")

    if [ -n "$SYS_BIN" ]; then
        echo "🔗 Bridging $PKG..."

        # 1. Create the package-specific directory Mason expects
        mkdir -p "$PACKAGES_DIR/$PKG"

        # 2. Link binary into the package directory
        # Some LSPs need the link name to match the PKG name exactly
        ln -sf "$SYS_BIN" "$PACKAGES_DIR/$PKG/$PKG"

        # 3. Link binary into Mason's global bin directory
        ln -sf "$SYS_BIN" "$BIN_DIR/$PKG"

        echo "✅ $PKG is now 'Mason-ified'"
    else
        echo "⚠️  Skipping $PKG: Not found in system PATH. (pkg install $PKG?)"
    fi
done

echo "🎉 Done! Restart Neovim and check :Mason"
