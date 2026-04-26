return {
  'benomahony/uv.nvim',
  ft = { 'python' }, -- Lazy loads when opening Python files
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    picker_integration = true,
  },
}
