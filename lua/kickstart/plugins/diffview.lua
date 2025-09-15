return {
  {
    'sindrets/diffview.nvim',
    config = function()
      -- Open and close
      vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<CR>', {
        desc = 'Open Diffview',
      })

      vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', {
        desc = 'Close Diffview',
      })

      -- Global toggle for the file panel inside Diffview
      vim.keymap.set('n', '<leader>df', '<cmd>DiffviewToggleFiles<CR>', {
        desc = 'Toggle Diffview file panel',
      })
    end,
  },
}
