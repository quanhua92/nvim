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
        accept = '<C-j>', -- Ctrl + j to accept
        next = '<M-]>',   -- Alt + ] for next
        prev = '<M-[>',   -- Alt + [ for prev
        dismiss = '<C-]>', -- Ctrl + ] to hide
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true, -- Enable in markdown files
      help = true,     -- Enable in help files
    },
  },
}

