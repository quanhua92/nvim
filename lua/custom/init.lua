vim.opt.colorcolumn = "80"

vim.keymap.set("n", "ZZ", "zz<cr>")

-- set relative number
vim.o.relativenumber = true

-- set highlight search
vim.o.hlsearch = false

-- vim-visual-multi
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
}
