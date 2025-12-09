local M = {}

M.disable_filetypes = { c = true, cpp = true, php = true, ts = true, js = true, tsx = true, jsx = true }

M.get_root_dir = function(dirname)
  return vim.fs.root(dirname, { '.phpcs.xml', 'phpcs.xml', '.phpcs.xml.dist', 'phpcs.xml.dist', '.git' })
end

M.format_opts = function()
  local lsp_format = 'fallback'

  local filetype = vim.bo.filetype
  if M.disable_filetypes[filetype] then
    lsp_format = 'never'
  end

  return {
    -- async = true, -- needed for phpcbf as it takes FOREVER to run and will otherwise timeout -- pass true to run formatter without blocking but edits in the buffer will cause formats to get discarded.
    timeout_ms = 3000,
    lsp_format = lsp_format,
  }
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
          require('conform').format(M.format_opts())
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.

        if vim.api.nvim_buf_get_name(bufnr):match '%.ts$' then
          return nil
        elseif M.disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return M.format_opts()
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'phpcbf' },
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
      formatters = {
        phpcbf = {
          command = function(self, ctx)
            -- local root = vim.fs.root(ctx.dirname, { '.git' })
            -- vim.fs.root(ctx.dirname, { '.phpcs.xml', 'phpcs.xml', '.phpcs.xml.dist', 'phpcs.xml.dist', '.git' })

            local root = M.get_root_dir(ctx.dirname)

            -- Use the closest vendored phpcbf if it exists
            if root ~= nil then
              local path = vim.fs.joinpath(root, 'vendor', 'bin', 'phpcbf')
              local stat = vim.uv.fs_stat(path)
              if stat and stat.type == 'file' then
                return path
              end
            end
            return 'phpcbf'
          end,
          -- args = { '--standard=.', '-' }, -- "." tells phpcbf to search upward
          stdin = true,
          cwd = function(self, ctx)
            -- local root = vim.fs.root(ctx.dirname, { '.phpcs.xml', 'phpcs.xml', '.phpcs.xml.dist', 'phpcs.xml.dist', '.git' })
            local root = M.get_root_dir(ctx.dirname)
            -- local root = vim.fs.root(ctx.dirname, { '.git' })
            -- use the closest phpcs config file if it exists
            if root ~= nil then
              return root
            end

            return ctx.dirname
          end,
        },
      },
    },
  },
}
