-- uv.nvim: run/manage Python files through uv
vim.pack.add {
  'https://github.com/benomahony/uv.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
}
require('uv').setup {
  picker_integration = true,
  silent = true,
}
