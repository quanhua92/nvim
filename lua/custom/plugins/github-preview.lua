-- github-preview.nvim: live markdown render at localhost:9999
vim.pack.add { 'https://github.com/wallpants/github-preview.nvim' }
local gpreview = require('github-preview')
gpreview.setup { host = '0.0.0.0', port = 9999 }
local fns = gpreview.fns
vim.keymap.set('n', '<leader>mpt', fns.toggle)
vim.keymap.set('n', '<leader>mps', fns.single_file_toggle)
vim.keymap.set('n', '<leader>mpd', fns.details_tags_toggle)
