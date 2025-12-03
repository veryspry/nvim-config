vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<CR>', { desc = '[D]iffview [O]pen' })
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', { desc = '[D]iffview [C]lose' })

return {
  { 'sindrets/diffview.nvim' },
}
