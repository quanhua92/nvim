-- GitHub Copilot: inline ghost-text suggestions
-- Build/auth hook is handled by the PackChanged autocmd in init.lua SECTION 3
vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua' }
require('copilot').setup {
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
}
