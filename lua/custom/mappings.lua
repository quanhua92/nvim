local M = {}

M.disabled = {
  n = {
    ["<leader>ma"] = "",
    ["<leader>n"] = "",
    ["<leader>rn"] = "",
    ["<leader>th"] = "",
  },
}

M.custom = {
  n = {
    ["<leader>ts"] = {
      function()
        vim.o.hlsearch = not vim.o.hlsearch
      end,
      "toggle hlsearch",
    },
    ["<leader>tr"] = {
      function()
        vim.o.relativenumber = not vim.o.relativenumber
      end,
      "toggle relative number",
    },
  },
  i = {
    ["jk"] = {"<esc>", "jk to enter normal mode"},
    ["kj"] = {"<esc>", "kj to enter normal mode"},
  },
  t = {
    [",,"] = {"<C-\\><C-n>", "jk to enter normal mode"},
  }
}

M.harpoon = {
  n = {
    ["<C-e>"] = { ":lua require('harpoon.ui').toggle_quick_menu() <CR>", "harpoon toggle_quick_menu" },
    ["<leader>me"] = { ":lua require('harpoon.ui').toggle_quick_menu() <CR>", "harpoon toggle_quick_menu" },
    ["<leader>ma"] = { ":lua require('harpoon.mark').add_file() <CR>", "harpoon add_file" },
    ["<leader>mc"] = { ":lua require('harpoon.mark').clear_all() <CR>", "harpoon clear_all" },
    ["<leader>mn"] = { ":lua require('harpoon.ui').nav_next() <CR>", "harpoon nav_next" },
    ["<leader>mp"] = { ":lua require('harpoon.ui').nav_prev() <CR>", "harpoon nav_prev" },
  },
}

M.rust_tools = {
  n = {
    ["<leader>rr"] = { "<cmd> RustHoverActions <CR>", "RustHoverActions" },
  },
}

M.general = {
  n = {
    ["<leader>tn"] = { "<cmd> set nu! <CR>", "toggle line number" },
  }
}

M.telescope = {
  plugin = true,
  n = {
    ["<leader>tt"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },
  }
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<M-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<M-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
    
    ["<M-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<M-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },
    ["<M-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<M-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },
  },
}

return M
