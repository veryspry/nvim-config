local get_lsp_format_opt = function()
  local bufnr = vim.fn.bufnr()
  local disable_filetypes = {
    c = true,
    cpp = true,
    typescript = true,
    javascript = true,
    typescriptreact = true,
    javascriptreact = true,
  }
  local lsp_format_opt
  if disable_filetypes[vim.bo[bufnr].filetype] then
    lsp_format_opt = 'never'
  else
    lsp_format_opt = 'fallback'
  end
  return lsp_format_opt
end

local eslint_format = function()
  if vim.fn.exists 'EslintFixAll' then
    vim.cmd 'EslintFixAll'
  end
  -- return empty so conform api does not break
  return {}
end

return {

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format {
            async = true,
            lsp_format = get_lsp_format_opt(),
          }
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_format = get_lsp_format_opt(),
        }
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        -- local disable_filetypes = { c = true, cpp = true, php = true, ts = true, js = true, tsx = true, jsx = true }

        -- if vim.api.nvim_buf_get_name(bufnr):match '%.ts$' then
        --   return nil
        -- elseif disable_filetypes[vim.bo[bufnr].filetype] then
        --   return nil
        -- else
        --   return {
        --     timeout_ms = 500,
        --     lsp_format = 'fallback',
        --   }
        -- end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- typescript = eslint_format,
        -- typescriptreact = eslint_format,
        -- javascript = eslint_format,
        -- javascriptreact = eslint_format,

        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
