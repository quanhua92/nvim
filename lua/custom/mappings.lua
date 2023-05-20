local M = {}

M.disabled = {
  n = {
    ["<leader>ma"] = "",
  },
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

return M
