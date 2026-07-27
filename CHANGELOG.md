# Changelog

Exact changes layered on top of kickstart.nvim. Each section shows the precise code so it can be re-applied to a fresh install.

Legend: `init.lua` = main config, `lua/custom/plugins/*.lua` = lazy plugin specs, `lua/kickstart/plugins/*.lua` = built-in optional modules.

---

## 1. UI & Editor Basics
**File:** `init.lua`

```lua
vim.g.have_nerd_font = true        -- was false
vim.o.relativenumber = true        -- was commented out
```

---

## 2. Neo-tree (file explorer)
**Files:** `init.lua`, `lua/kickstart/plugins/neo-tree.lua`

`init.lua` — enable the module + keymaps:
```lua
-- In lazy.setup import list (was commented out):
require 'kickstart.plugins.neo-tree',
{ import = 'custom.plugins' },

-- Keymaps (in Basic Keymaps section):
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { desc = 'Focus Neo-tree' })
```

`lua/kickstart/plugins/neo-tree.lua` — add to `opts.filesystem`:
```lua
follow_current_file = {
  enabled = true,        -- reveal the active buffer's file
  leave_dirs_open = false,
},
```

---

## 3. Bufferline (tabs)
**Files:** `init.lua`, `lua/custom/plugins/bufferline.lua`

`lua/custom/plugins/bufferline.lua` (new):
```lua
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      mode = "buffers",
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        }
      },
    }
  }
}
```

`init.lua` — keymaps:
```lua
-- Cycle
vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Tab' })
vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Tab' })

-- Jump to buffer N
vim.keymap.set('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', { desc = 'Tab 1' })
vim.keymap.set('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', { desc = 'Tab 2' })
vim.keymap.set('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', { desc = 'Tab 3' })
vim.keymap.set('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', { desc = 'Tab 4' })
vim.keymap.set('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', { desc = 'Tab 5' })

-- Move
vim.keymap.set('n', '<S-Left>', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move Tab Left' })
vim.keymap.set('n', '<S-Right>', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move Tab Right' })

-- Close
vim.keymap.set('n', '<leader>bd', '<cmd>bp|bd #<cr>', { desc = 'Close Current Tab' })
vim.keymap.set('n', '<leader>bq', ':q<CR>', { desc = '[B]uffer [Q]uit window' })
vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close Other Tabs' })
```

---

## 4. Better Escape
**File:** `lua/custom/plugins/better-escape.lua` (new)

```lua
return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
  end,
}
```
Typing `jk` in insert mode exits to normal.

---

## 5. Copilot
**File:** `lua/custom/plugins/copilot.lua` (new)

```lua
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-j>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
```

---

## 6. Telescope find keys
**File:** `init.lua` (inside `telescope` config, after `local builtin = require 'telescope.builtin'`)

```lua
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind [Word] by Grep' })
vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S]earch [J]umplist' })
vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
```

Top-level keymap:
```lua
vim.keymap.set('n', '<leader>wf', '<Plug>(WayfinderOpen)', { desc = 'Wayfinder' })
```

Conform format key changed from `<leader>f` → `<leader>fc`:
```lua
-- In conform.nvim keys = { ... }
{
  '<leader>fc',
  function() require('conform').format { async = true } end,
  mode = '',
  desc = '[F]ormat [C]ode',
},
```

---

## 7. LSP servers
**File:** `init.lua` (inside `lspconfig` setup, `local servers = { ... }`)

```lua
jsonls = {},
ts_ls = {},
rust_analyzer = {},
pyright = {
  cmd = (function()
    local root = vim.fs.root(0, { 'pyproject.toml', 'pyrightconfig.json' })
    if root then
      local local_python = root .. '/.venv/bin/python'
      if vim.fn.executable(local_python) == 1 then return { local_python, '-m', 'pyright.langserver', '--stdio' } end
    end
    return { 'pyright-langserver', '--stdio' }
  end)(),
  settings = {
    python = {
      analysis = {
        useLibraryCodeForTypes = true,
        indexing = false,
        autoImportCompletions = false,
      },
    },
  },
},
ruff = {
  on_init = function(client)
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false  -- don't fight pyright
    end
  end,
},
```

`gd` alias for go-to-definition (alongside `grd`):
```lua
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
```

---

## 8. Python workflow
**Files:** `lua/custom/plugins/uv.lua` (new), `init.lua`

`lua/custom/plugins/uv.lua` (new):
```lua
return {
  'benomahony/uv.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    picker_integration = true,
    silent = true,
  },
}
```

`init.lua` — run current file with UV (autocmd, buffer-local keymap):
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>r', ':UVRunFile<CR>', { buffer = true, desc = '[R]un Python with UV' })
  end,
})
```

`init.lua` — format-on-save + formatters (in `conform.nvim` setup):
```lua
-- format_on_save lambda:
local enabled_filetypes = { python = true }

-- formatters_by:
python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
```

---

## 9. Terminal mode
**File:** `init.lua` (Basic Keymaps section)

```lua
-- Exit / navigate from inside a terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Move to left window' })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Move to bottom window' })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Move to top window' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Move to right window' })

-- Create terminals
vim.keymap.set('n', '<leader>tb', ':botright split | resize 15 | term<CR>', { desc = '[T]erminal [B]ottom' })
vim.keymap.set('n', '<leader>tt', ':topleft split | resize 15 | term<CR>', { desc = '[T]erminal [T]op' })
vim.keymap.set('n', '<leader>tc', ':botright split | resize 15 | terminal cd %:p:h && $SHELL<CR>', { desc = '[T]erminal [C]urrent dir' })
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { desc = '[T]erminal [V]ertical' })
vim.keymap.set('n', '<leader>tn', ':tabnew | terminal<CR>', { desc = '[T]erminal [N]ew tab' })
```

Auto-enter insert on open:
```lua
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-terminal', { clear = true }),
  callback = function() vim.cmd 'startinsert' end,
})
```

which-key group rename:
```lua
-- was: { '<leader>t', group = '[T]oggle' }
{ '<leader>t', group = '[T]erminal' },
```

---

## 10. Window resize
**File:** `init.lua` (Basic Keymaps section)

```lua
vim.keymap.set('n', '<C-w>/', function()
  local width = math.floor(vim.o.columns * 0.66)
  vim.cmd('vertical resize ' .. width)
end, { desc = 'Window: set 2/3 width' })

vim.keymap.set('n', '<C-w>?', function()
  local width = math.floor(vim.o.columns * 0.33)
  vim.cmd('vertical resize ' .. width)
end, { desc = 'Window: set 1/3 width' })
```

---

## 11. blink.cmp (completion)
**File:** `init.lua` (blink.cmp `opts.keymap`)

```lua
preset = 'enter',  -- was 'default'

['<S-Tab>'] = {
  'snippet_backward',
  function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-d>', true, true, true), 'n', true)
  end,
},
```

---

## 12. Preview plugins
**Files:** `lua/custom/plugins/code-preview.lua` (new), `lua/custom/plugins/github-preview.lua` (new)

`lua/custom/plugins/code-preview.lua` (new):
```lua
return {
  "Cannon07/code-preview.nvim",
  config = function()
    require("code-preview").setup()
  end,
}
```

`lua/custom/plugins/github-preview.lua` (new):
```lua
return {
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    keys = { "<leader>mpt" },
    opts = {
        host = "0.0.0.0",
        port = 9999
    },
    config = function(_, opts)
        local gpreview = require("github-preview")
        gpreview.setup(opts)
        local fns = gpreview.fns
        vim.keymap.set("n", "<leader>mpt", fns.toggle)
        vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
        vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
    end,
}
```

---

## 13. Tooling & infra

### termux_bridge_mason.sh
Symlinks system binaries into Mason's dirs so LSPs work on Termux. Targets:
`stylua`, `ruff`, `lua-language-server`, `rust-analyzer`, `pyright`, `clangd`, `gopls`, `bash-language-server`.

### README.md
Added a copy-paste block installing system deps: ripgrep, fd-find, node (via nvm), rust (rustup), tree-sitter-cli.

### vim-visual-multi (added then removed)
Added `mg979/vim-visual-multi` with custom keys, then removed it because Copilot's `<C-j>` conflicted with multi-cursor.
