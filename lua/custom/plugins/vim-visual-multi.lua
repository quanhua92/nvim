return {
  'mg979/vim-visual-multi',
  init = function()
    -- Disable the default mappings like Shift-Arrow
    vim.g.VM_default_mappings = 0

    -- Only enable the keys you actually want
    vim.g.VM_maps = {
      -- This is REQUIRED to prevent a conflict with Copilot <C-j>
      ['Find Under'] = '<C-n>',
      ['Find Next'] = 'n',
      ['Select All'] = '<C-a>',         -- Optional: Select all occurrences
      ['Add Cursor Down'] = '<C-Down>', -- Use Ctrl + Down Arrow
      ['Add Cursor Up'] = '<C-Up>',     -- Use Ctrl + Up Arrow
    }
  end,
}

