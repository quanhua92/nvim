local null_ls = require "null-ls"

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local b = null_ls.builtins

local sources = {
  -- rust
  b.formatting.rustfmt,

  -- webdev
  b.formatting.prettierd,
  b.diagnostics.eslint_d.with { diagnostics_format = "[eslint] #{m}\n(#{c})" },

  -- Lua
  b.formatting.stylua,

  -- python
  b.formatting.black,

  -- Cpp
  b.formatting.clang_format,

  -- SQL: apt install pgformatter
  b.formatting.pg_format,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

null_ls.setup {
  debug = true,
  sources = sources,
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.format { bufnr = bufnr }
          -- vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
}
