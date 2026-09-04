-- Modus Vivendi with the black surfaces used by the daily Helix configuration.
Config.now(function()
  require('modus-themes').setup({
    style = 'modus_vivendi',
    line_nr_column_background = false,
    sign_column_background = false,
    on_highlights = function(highlights, colors)
      local black = '#000000'
      local statusline = '#111111'
      local completion_selection = '#3a3a3a'

      highlights.Normal = { fg = colors.fg_main, bg = black }
      highlights.NormalFloat = { fg = colors.fg_main, bg = black }
      highlights.NormalNC = { fg = colors.fg_main, bg = black }
      highlights.Pmenu = { fg = colors.fg_main, bg = black }
      highlights.PmenuSel = { fg = '#ffffff', bg = completion_selection }
      highlights.PmenuKindSel = { fg = '#ffffff', bg = completion_selection }
      highlights.PmenuExtraSel = { fg = '#ffffff', bg = completion_selection }
      highlights.PmenuMatchSel = { fg = '#ffffff', bg = completion_selection, bold = true }
      highlights.PmenuSbar = { bg = black }
      highlights.PmenuThumb = { bg = colors.fg_dim }
      highlights.LineNr = { fg = colors.fg_dim, bg = black }
      highlights.CursorLineNr = { fg = '#feacd0', bg = black, bold = true }
      highlights.SignColumn = { bg = black }
      highlights.StatusLine = { fg = colors.fg_main, bg = statusline }
      highlights.StatusLineNC = { fg = '#cccccc', bg = statusline }
      highlights.MiniStatuslineModeNormal = { fg = '#88ca9f', bg = statusline, bold = true }
      highlights.MiniStatuslineModeInsert = { fg = '#ff9580', bg = statusline, bold = true }
      highlights.MiniStatuslineModeVisual = { fg = '#d2b580', bg = statusline, bold = true }
      highlights.MiniStatuslineFilename = { fg = colors.fg_main, bg = statusline }
      highlights.MiniStatuslineInactive = { fg = '#cccccc', bg = statusline }
      highlights.AerialNormal = { fg = colors.fg_main, bg = black }
      highlights.AerialLine = { fg = colors.fg_main, bg = '#1e1e1e' }
      highlights.AerialGuide = { fg = colors.fg_dim, bg = black }
    end,
  })

  vim.cmd.colorscheme('modus')
end)
