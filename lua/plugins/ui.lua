return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  {
    'echasnovski/mini.statusline',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local statusline = require('mini.statusline')

      -- Custom diagnostics with colored icons
      local function section_diagnostics()
        local hasLsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
        if not hasLsp then return '' end

        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

        local parts = {}
        if errors > 0 then
          table.insert(parts, '%#DiagnosticError#● ' .. errors)
        end
        if warnings > 0 then
          table.insert(parts, '%#DiagnosticWarn#● ' .. warnings)
        end

        if #parts == 0 then return '' end
        return table.concat(parts, ' ') .. '%*'
      end

      -- Custom filename: icon + parent/filename, bold when modified
      local function section_fileinfo()
        local filename = vim.fn.expand('%:t')
        if filename == '' then return '[No Name]' end

        local parent = vim.fn.expand('%:p:h:t')
        local display = parent ~= '' and (parent .. '/' .. filename) or filename

        -- Get file icon
        local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
        local icon = ''
        if devicons_ok then
          local ext = vim.fn.expand('%:e')
          icon = devicons.get_icon(filename, ext, { default = true }) or ''
          icon = icon .. ' '
        end

        -- Modified indicator with highlight
        local modified = ''
        if vim.bo.modified then
          modified = ' %#StatusLineModified#●%*'
        end

        -- Bold filename when modified
        if vim.bo.modified then
          return '%#StatusLineFileModified#' .. icon .. display .. '%*' .. modified
        end
        return icon .. display
      end

      -- Custom location section
      local function section_location()
        return 'Ln %l:%c'
      end

      statusline.setup({
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 75 })
            local diagnostics = section_diagnostics()
            local fileinfo = section_fileinfo()
            local location = section_location()

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              diagnostics,
              '%=',
              { hl = 'MiniStatuslineFilename', strings = { fileinfo } },
              { hl = 'MiniStatuslineFileinfo', strings = { location } },
            })
          end,
          inactive = function()
            local filename = vim.fn.expand('%:t')
            if filename == '' then filename = '[No Name]' end
            local parent = vim.fn.expand('%:p:h:t')
            local display = parent ~= '' and (parent .. '/' .. filename) or filename
            return '%#MiniStatuslineInactive#%= ' .. display .. ' %='
          end,
        },
        use_icons = true,
      })

      -- Custom highlights for modified state
      vim.api.nvim_set_hl(0, 'StatusLineModified', { fg = '#ff9e64', bold = true })
      vim.api.nvim_set_hl(0, 'StatusLineFileModified', { fg = '#c0caf5', bold = true })
    end,
  },
}
