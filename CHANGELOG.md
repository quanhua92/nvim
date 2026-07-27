# Changelog

My personal customizations on top of kickstart.nvim. Migrated from lazy.nvim to **vim.pack** (upstream PR #2005). Each section shows exact code in the current `do/end` section layout.

---

## Prerequisites (beyond stock kickstart)

Stock kickstart already requires: `git`, `make`, `unzip`, C compiler (`gcc`), `ripgrep`, `fd-find`, `tree-sitter CLI`, optional Nerd Font.

| External tool | Required by | Install | If missing |
|---|---|---|---|
| **Nerd Font** | bufferline, neo-tree icons (SECTION 1 sets `have_nerd_font = true`) | [nerdfonts.com](https://www.nerdfonts.com/) | Icons render as boxes; set `have_nerd_font = false` |
| **Node.js + npm** | pyright LSP, jsonls/ts_ls | `curl -fsSL https://deb.nodesource.com/setup_20.x \| sudo -E bash - && sudo apt install -y nodejs` | jsonls/ts_ls auto-skip (conditional on `npm`); pyright won't install via Mason |
| **Python 3** | pyright venv detection (`<leader>r`), ruff | `sudo apt install -y python3` | pyright/ruff won't install via Mason |
| **uv** | `<leader>r` runs `:UVRunFile` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `<leader>r` is a no-op; uv.nvim loads but command fails |
| **Rust toolchain** | rust_analyzer LSP | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | rust_analyzer won't install via Mason |
| **GitHub Copilot subscription** | copilot.lua (`<C-j>` accept) | `:Copilot auth` on first run | Plugin loads but no suggestions appear |

---

## 1. UI & Editor Basics — `init.lua` SECTION 1
```lua
vim.g.have_nerd_font = true          -- was false
vim.o.relativenumber = true          -- was commented out
```

## 2. Neo-tree — `init.lua` SECTION 2 + `lua/kickstart/plugins/neo-tree.lua`
SECTION 2 keymaps:
```lua
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { desc = 'Focus Neo-tree' })
```
SECTION 10: `require 'kickstart.plugins.neo-tree'` (uncommented)
neo-tree.lua — add to `require('neo-tree').setup` filesystem opts:
```lua
follow_current_file = { enabled = true, leave_dirs_open = false },
```

## 3. Bufferline (tabs) — `init.lua` SECTION 2 + `lua/custom/plugins/bufferline.lua`
SECTION 2 keymaps:
```lua
vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Tab' })
vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Tab' })
-- jump <leader>1..5, move <S-Left>/<S-Right>
vim.keymap.set('n', '<leader>bd', '<cmd>bp|bd #<cr>', { desc = 'Close Current Tab' })
vim.keymap.set('n', '<leader>bq', ':q<CR>', { desc = '[B]uffer [Q]uit window' })
vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close Other Tabs' })
```
bufferline.lua (vim.pack):
```lua
vim.pack.add {
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
}
require('bufferline').setup { options = { mode = 'buffers', offsets = { { filetype = 'neo-tree', ... } } } }
```

## 4. Better Escape — `lua/custom/plugins/better-escape.lua`
```lua
vim.pack.add { 'https://github.com/max397574/better-escape.nvim' }
require('better_escape').setup {}
```

## 5. Copilot — `lua/custom/plugins/copilot.lua` + `init.lua` SECTION 3
copilot.lua (vim.pack): `<C-j>` accept, `<M-]>`/`<M-[>` next/prev, `<C-]>` dismiss, auto_trigger.
SECTION 3 PackChanged hook:
```lua
if name == 'copilot.lua' then vim.schedule(function() vim.cmd 'Copilot auth' end) return end
```

## 6. Telescope find keys — `init.lua` SECTION 5
```lua
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [Word] by Grep' })
vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S]earch [J]umplist' })
vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
```
Conform format key: `<leader>f` → `<leader>fc` (SECTION 7).

## 7. LSP servers — `init.lua` SECTION 6
```lua
local servers = {
  jsonls = {}, ts_ls = {}, rust_analyzer = {},
  pyright = { cmd = venv-aware, settings = { python = { analysis = { indexing = false, ... } } } },
  ruff = { on_init = disable hoverProvider },
  ...
}
-- gd alias for go-to-definition (SECTION 5 LspAttach):
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
```

## 8. Python workflow — `lua/custom/plugins/uv.lua` + `init.lua` SECTION 2/7
uv.lua (vim.pack): `picker_integration = true, silent = true`
SECTION 2 autocmd: `<leader>r` → `:UVRunFile<CR>` (buffer-local, python only)
SECTION 7: `enabled_filetypes = { python = true }`, `formatters_by_ft = { python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' } }`

## 9. Terminal mode — `init.lua` SECTION 2
`<Esc>`/`<C-hjkl>` from terminal; `<leader>tb/tt/tc/tv/tn` to create; `TermOpen` → startinsert. which-key `<leader>t` group = `[T]erminal` (SECTION 4).

## 10. Window resize — `init.lua` SECTION 2
```lua
<C-w>/  → vertical resize to floor(columns * 0.66)   (2/3)
<C-w>?  → vertical resize to floor(columns * 0.33)   (1/3)
```

## 11. blink.cmp — `init.lua` SECTION 8
```lua
preset = 'enter',
['<S-Tab>'] = { 'snippet_backward', <feed <C-d> for un-indent> },
```

## 12. Preview plugins — `lua/custom/plugins/code-preview.lua`, `github-preview.lua`
code-preview.nvim: inline preview. github-preview.nvim: `localhost:9999`, `<leader>mpt/mps/mpd`.

## 13. Tooling & infra
- `termux_bridge_mason.sh`: symlinks system binaries into Mason dirs for Termux.
- README: deps install block under "Install External Dependencies".

## Migration note
Ported from lazy.nvim → vim.pack on 2026-07-28. Plugin specs in `lua/custom/plugins/*.lua` were rewritten from LazySpec tables to self-executing `vim.pack.add` + `setup()` calls. Old lazy.nvim version preserved on branch `backup/lazy-config`.
