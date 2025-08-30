# Neovim config

### Steps taken when modifying configuration:
- Enable relative numbers
- Enable nerd font
- Remove auto-indent from vim for TS/JSX/TSX/JS files:
    ```
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          callback = function()
            -- Turn off Vim's indent logic
            vim.bo.autoindent = false
            vim.bo.smartindent = false
            vim.bo.cindent = false
            vim.bo.indentexpr = ''
            -- Force consistent tab settings (Biome defaults to 2 spaces)
            vim.bo.shiftwidth = 2
            vim.bo.tabstop = 2
            vim.bo.expandtab = true
          end,
        })
    ```
- Enable searching hidden files also with Telescope
    ```
      vim.keymap.set('n', '<leader>sfh', function()
        require('telescope.builtin').find_files { hidden = true, no_ignore = true }
      end, { desc = '[S]earch [F]iles [H]idden' })
    ```
- Add the following servers to LSP servers:
    - `ts_ls`
    - `javascript`
    - `jsonls`
    - `tailwindcss`
- Add `prettierd | prettier` to `Autoformat` for `typescriptreact`
