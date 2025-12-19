return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup()

      require('nvim-dap-virtual-text').setup()

      -- Handled by nvim-dap-go
      -- dap.adapters.go = {
      --   type = "server",
      --   port = "${port}",
      --   executable = {
      --     command = "dlv",
      --     args = { "dap", "-l", "127.0.0.1:${port}" },
      --   },
      -- }

      -- local elixir_ls_debugger = vim.fn.exepath 'elixir-ls-debugger'
      -- if elixir_ls_debugger ~= '' then
      --   dap.adapters.mix_task = {
      --     type = 'executable',
      --     command = elixir_ls_debugger,
      --   }
      --
      --   dap.configurations.elixir = {
      --     {
      --       type = 'mix_task',
      --       name = 'phoenix server',
      --       task = 'phx.server',
      --       request = 'launch',
      --       projectDir = '${workspaceFolder}',
      --       exitAfterTaskReturns = false,
      --       debugAutoInterpretAllModules = false,
      --     },
      --   }
      -- end

      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv 'HOME' .. '/code/vscode-php-debug/out/phpDebug.js' },
      }

      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9000,
          log = true,
          -- localSourceRoot = os.getenv 'HOME' .. '/Users/Local Sites/',
        },
      }

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<leader>dr', dap.restart, { desc = '[D]ebug [R]estart' })
      vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug [R]estart' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}

-- return {
--   {
--     'mfussenegger/nvim-dap',
--     -- event = 'VeryLazy',
--     config = function()
--       local dap = require 'dap'
--       local widgets = require 'dap.ui.widgets'
--
--       require('telescope').load_extension 'dap'
--
--       dap.adapters.php = {
--         type = 'executable',
--         command = 'node',
--         args = { os.getenv 'HOME' .. '/code/vscode-php-debug/out/phpDebug.js' },
--       }
--
--       dap.configurations.php = {
--         {
--           type = 'php',
--           request = 'launch',
--           name = 'Listen for Xdebug',
--           port = 9000,
--           log = true,
--           localSourceRoot = os.getenv 'HOME' .. '/Users/Local Sites/',
--         },
--       }
--
--       vim.keymap.set('n', '<F5>', function()
--         dap.continue()
--       end, { desc = 'Debugger continue' })
--
--       vim.keymap.set('n', '<F10>', function()
--         dap.step_over()
--       end, { desc = 'Debugger step over' })
--
--       vim.keymap.set('n', '<F11>', function()
--         dap.step_into()
--       end, { desc = 'Debugger step into' })
--
--       vim.keymap.set('n', '<F12>', function()
--         dap.step_out()
--       end, { desc = 'Debugger step out' })
--
--       vim.keymap.set('n', '<Leader>b', function()
--         dap.toggle_breakpoint()
--       end, { desc = 'Debugger toggle breakpoint' })
--
--       vim.keymap.set('n', '<Leader>B', function()
--         dap.set_breakpoint()
--       end, { desc = 'Debugger set breakpoint' })
--
--       vim.keymap.set('n', '<Leader>lp', function()
--         dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
--       end, { desc = 'Debugger set breakpoint with message' })
--
--       -- vim.keymap.set('n', '<Leader>dr', function()
--       --   dap.repl.open()
--       -- end, { desc = '' })
--
--       -- vim.keymap.set('n', '<Leader>dl', function()
--       --   dap.run_last()
--       -- end)
--
--       -- vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
--       --   widgets.hover()
--       -- end)
--
--       -- vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
--       --   widgets.preview()
--       -- end)
--
--       -- vim.keymap.set('n', '<Leader>df', function()
--       --   widgets.centered_float(widgets.frames)
--       -- end)
--
--       -- vim.keymap.set('n', '<Leader>ds', function()
--       --   widgets.centered_float(widgets.scopes)
--       -- end)
--     end,
--   },
--   { 'theHamsta/nvim-dap-virtual-text' },
--   {
--     'rcarriga/nvim-dap-ui',
--     dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
--     config = function()
--       require('lazydev').setup {
--         library = { 'nvim-dap-ui' },
--       }
--     end,
--   },
--   {
--     'nvim-telescope/telescope-dap.nvim',
--     dependencies = {
--       'mfussenegger/nvim-dap',
--       'nvim-telescope/telescope.nvim',
--       'nvim-treesitter/nvim-treesitter',
--     },
--   },
-- }
