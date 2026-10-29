vim.keymap.set('n', '<leader>gdo', '<cmd>DiffviewOpen<CR>', { desc = '[G]it [D]iffview [O]pen' })
vim.keymap.set('n', '<leader>gdc', '<cmd>DiffviewClose<CR>', { desc = '[G]it [D]iffview [C]lose' })

return {
  { 'sindrets/diffview.nvim' },
}
