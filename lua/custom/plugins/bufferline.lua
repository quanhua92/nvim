-- Bufferline: tab/buffer bar with neo-tree offset
vim.pack.add {
  { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-tree/nvim-web-devicons',
}
require('bufferline').setup {
  options = {
    mode = 'buffers',
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'File Explorer',
        text_align = 'left',
        separator = true,
      },
    },
  },
}
