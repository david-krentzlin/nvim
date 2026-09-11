-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Completion ================================================================

now_if_args(function()
  add({ {
    src = 'https://github.com/Saghen/blink.cmp',
    version = vim.version.range('1.*'),
  } })

  local ok, blink = pcall(require, 'blink.cmp')
  if not ok then return end

  blink.setup({
    completion = {
      ghost_text = { enabled = true, show_with_menu = false },
      menu = { auto_show = false },
    },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  })

  vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })
end)

-- File explorer ==============================================================

later(function()
  add({ 'https://github.com/stevearc/oil.nvim' })

  require('oil').setup({
    default_file_explorer = true,
    columns = { 'icon' },
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    lsp_file_methods = { enabled = true },
    view_options = { show_hidden = false },
    keymaps = {
      ['-'] = 'actions.parent',
      ['^'] = 'actions.parent',
      ['q'] = 'actions.close',
    },
  })
end)

-- Code outline ==============================================================

Config.later(function()
  add({ 'https://github.com/stevearc/aerial.nvim' })

  Config.aerial_kinds = {
    'Class',
    'Constructor',
    'Enum',
    'Function',
    'Interface',
    'Module',
    'Method',
    'Struct',
  }

  local icons = {}
  local mini_icons = require('mini.icons')
  for _, kind in ipairs(Config.aerial_kinds) do
    icons[kind] = mini_icons.get('lsp', kind)
  end

  Config.aerial_config = {
    backends = { 'treesitter', 'lsp', 'markdown', 'man' },
    filter_kind = Config.aerial_kinds,
    highlight_mode = 'last',
    highlight_on_hover = true,
    highlight_closest = true,
    autojump = true,
    open_automatic = false,
    layout = {
      default_direction = 'left',
      min_width = 28,
      placement = 'edge',
    },
    icons = icons,
  }

  require('aerial').setup(Config.aerial_config)
end)

-- Git interface ==============================================================

later(function()
  add({ 'https://github.com/NeogitOrg/neogit' })

  require('neogit').setup()
  vim.keymap.set('n', '<Leader>v', '<Cmd>Neogit<CR>', { desc = 'Open Neogit' })
end)

-- Run commands ===============================================================

later(function()
  add({ {
    src = 'https://github.com/stevearc/overseer.nvim',
    version = vim.version.range('2.*'),
  } })

  require('overseer').setup()
  vim.api.nvim_create_user_command('OverseerRestartLast', function()
    local overseer = require('overseer')
    local task_list = require('overseer.task_list')
    local tasks = overseer.list_tasks({
      status = {
        overseer.STATUS.SUCCESS,
        overseer.STATUS.FAILURE,
        overseer.STATUS.CANCELED,
      },
      sort = task_list.sort_finished_recently,
    })

    if vim.tbl_isempty(tasks) then
      vim.notify('No completed Overseer task to restart', vim.log.levels.WARN)
      return
    end

    overseer.run_action(tasks[1], 'restart')
  end, { desc = 'Restart most recent Overseer task' })

  vim.cmd.cnoreabbrev('OS OverseerShell')
  vim.keymap.set('n', '<Leader>$$', '<Cmd>OverseerRun<CR>', { desc = 'Run Overseer task' })
  vim.keymap.set('n', '<Leader>$r', '<Cmd>OverseerRestartLast<CR>', { desc = 'Restart last Overseer task' })
  vim.keymap.set('n', '<Leader>$s', ':OverseerShell ', { desc = 'Run shell command with Overseer' })
  vim.keymap.set('n', '<Leader>$t', '<Cmd>OverseerToggle<CR>', { desc = 'Toggle Overseer' })
  vim.keymap.set('n', '<LocalLeader>tt', function()
    require('overseer').run_template({ tags = { require('overseer').TAG.TEST }, first = false })
  end, { desc = 'Run test task' })
end)

-- Run qfl on steroids =======================================================

later(function()
  add({ 'https://github.com/stevearc/quicker.nvim' })

  require('quicker').setup()
  vim.keymap.set('n', '<Leader>q', function() require('quicker').toggle() end, { desc = 'Toggle quickfix' })
  vim.keymap.set('n', '<A-n>', '<Cmd>cnext<CR>', { desc = 'Next quickfix item' })
  vim.keymap.set('n', '<A-p>', '<Cmd>cprevious<CR>', { desc = 'Previous quickfix item' })
end)

-- Statusline =================================================================

later(function()
  add({ 'https://github.com/nvim-lualine/lualine.nvim' })

  -- Upstream `examples/evil_lualine.lua`, with status components provided by
  -- the installed Overseer and Aerial plugins.
  local lualine = require('lualine')
  local highlight_color = function(group, attribute, fallback)
    local value = vim.api.nvim_get_hl(0, { name = group, link = false })[attribute]
    return value and string.format('#%06x', value) or fallback
  end
  local colors = {
    -- Match the former MiniStatusline background from 'plugin/25_theme.lua'.
    bg = '#111111',
    fg = highlight_color('StatusLine', 'fg', '#ffffff'),
    yellow = highlight_color('DiagnosticWarn', 'fg', '#ffff00'),
    cyan = highlight_color('DiagnosticInfo', 'fg', '#00ffff'),
    darkblue = highlight_color('DiffChange', 'bg', '#000080'),
    green = highlight_color('String', 'fg', '#00ff00'),
    orange = highlight_color('DiagnosticWarn', 'fg', '#ff8800'),
    violet = highlight_color('Identifier', 'fg', '#aa88ff'),
    magenta = highlight_color('Function', 'fg', '#ff00ff'),
    blue = highlight_color('DiagnosticHint', 'fg', '#00aaff'),
    red = highlight_color('DiagnosticError', 'fg', '#ff0000'),
  }
  local conditions = {
    buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
    hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  }
  local config = {
    options = {
      component_separators = '',
      section_separators = '',
      theme = {
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
    },
    sections = {
      lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
      lualine_c = {}, lualine_x = {},
    },
    inactive_sections = {
      lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
      lualine_c = {}, lualine_x = {},
    },
  }
  local ins_left = function(component) table.insert(config.sections.lualine_c, component) end
  local ins_right = function(component) table.insert(config.sections.lualine_x, component) end

  ins_left({ function() return '▊' end, color = { fg = colors.blue }, padding = { left = 0, right = 1 } })
  ins_left({
    function() return '' end,
    color = function()
      local mode_color = {
        n = colors.red, i = colors.green, v = colors.blue, ['\22'] = colors.blue,
        V = colors.blue, c = colors.magenta, no = colors.red, s = colors.orange,
        S = colors.orange, ['\19'] = colors.orange, ic = colors.yellow, R = colors.violet,
        Rv = colors.violet, cv = colors.red, ce = colors.red, r = colors.cyan,
        rm = colors.cyan, ['r?'] = colors.cyan, ['!'] = colors.red, t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  })
  ins_left({ 'filesize', cond = conditions.buffer_not_empty })
  ins_left({ 'filename', cond = conditions.buffer_not_empty, color = { fg = colors.magenta, gui = 'bold' } })
  ins_left({ 'location' })
  ins_left({ 'progress', color = { fg = colors.fg, gui = 'bold' } })
  ins_left({
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      error = { fg = colors.red }, warn = { fg = colors.yellow }, info = { fg = colors.cyan },
    },
  })
  ins_left({ function() return '%=' end })
  ins_left({
    function()
      local filetype = vim.bo.filetype
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if not client.config.filetypes or vim.tbl_contains(client.config.filetypes, filetype) then
          return client.name
        end
      end
      return 'No Active Lsp'
    end,
    icon = ' LSP:', color = { fg = colors.fg, gui = 'bold' },
  })
  ins_right({ 'aerial' })
  ins_right({ 'overseer' })
  ins_right({ 'o:encoding', fmt = string.upper, cond = conditions.hide_in_width, color = { fg = colors.green, gui = 'bold' } })
  ins_right({ 'fileformat', fmt = string.upper, icons_enabled = false, color = { fg = colors.green, gui = 'bold' } })
  ins_right({ 'branch', icon = '', color = { fg = colors.violet, gui = 'bold' } })
  ins_right({
    'diff', cond = conditions.hide_in_width,
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
    diff_color = {
      added = { fg = colors.green }, modified = { fg = colors.orange }, removed = { fg = colors.red },
    },
  })
  ins_right({ function() return '▊' end, color = { fg = colors.blue }, padding = { left = 1 } })

  lualine.setup(config)
end)

-- Multiple cursors ===========================================================

Config.now(function()
  add({ { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' } })

  local mc = require('multicursor-nvim')
  mc.setup()

  local modes = { 'n', 'x' }
  local set = function(lhs, rhs, desc)
    vim.keymap.set(modes, '<Leader>m' .. lhs, rhs, { desc = desc })
  end

  set('o', mc.addCursorOperator, 'Cursor Operator')
  set('j', function() mc.lineAddCursor(1) end, 'Cursor below')
  set('k', function() mc.lineAddCursor(-1) end, 'Cursor above')
  set('n', function() mc.matchAddCursor(1) end, 'Next match')
  set('N', function() mc.matchAddCursor(-1) end, 'Previous match')
  set('s', function() mc.matchSkipCursor(1) end, 'Skip next match')
  set('S', function() mc.matchSkipCursor(-1) end, 'Skip previous match')
  set('q', mc.toggleCursor, 'Toggle cursor synchronization')
  set('c', mc.clearCursors, 'Clear cursors')

  mc.addKeymapLayer(function(layer_set)
    layer_set(modes, '<C-p>', mc.prevCursor, { desc = 'Previous cursor' })
    layer_set(modes, '<C-n>', mc.nextCursor, { desc = 'Next cursor' })

    layer_set(modes, '<A-p>', function() mc.matchAddCursor(-1) end, { desc = "Previous match"})
    layer_set(modes, '<C-,>', function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
    layer_set(modes, '<A-n>', function() mc.matchAddCursor(1) end, { desc = 'Next match' })
    layer_set(modes, '<C-,>', function() mc.matchSkipCursor(-1) end, { desc = "Skip prev match" })

    layer_set(modes, '<C-c>', mc.deleteCursor, { desc = 'Delete cursor' })
    layer_set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
  end)
end)

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- - In case of errors related to queries for Neovim bundled parsers (like `lua`,
--   `vimdoc`, `markdown`, etc.), manually install them via 'nvim-treesitter'
--   with `:TSInstall <language>`. Be sure to have necessary system dependencies
--   (see MiniMax README section for software requirements).
now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Define languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  Config.treesitter_languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    'markdown_inline',
    'bash',
    'commonlisp',
    'elixir',
    'go',
    'gotmpl',
    'helm',
    'html',
    'json',
    'ruby',
    'rust',
    'scala',
    'yaml',
    -- No maintained Tree-sitter parser is available for Org.
    -- Add here more languages with which you want to use tree-sitter
    -- To see available languages:
    -- - Execute `:=require('nvim-treesitter').get_available()`
    -- - Visit 'SUPPORTED_LANGUAGES.md' file at
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, Config.treesitter_languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(Config.treesitter_languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  Config.start_treesitter = function(bufnr)
    local ok = pcall(vim.treesitter.start, bufnr)
    return ok
  end
  local ts_start = function(ev) Config.start_treesitter(ev.buf) end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Lisp structural editing ====================================================

now_if_args(function()
  add({ 'https://github.com/julienvincent/nvim-paredit' })

  require('nvim-paredit').setup({
    filetypes = { 'lisp' },
  })
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.lsp` to see potential issues.
now_if_args(function()
  add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/b0o/SchemaStore.nvim',
    'https://github.com/scalameta/nvim-metals',
  })

  -- Use `:h vim.lsp.enable()` to automatically enable language server based on
  -- the rules provided by 'nvim-lspconfig'.
  -- Use `:h vim.lsp.config()` or 'after/lsp/' directory to configure servers.
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require('conform').setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    -- formatters_by_ft = { lua = { 'stylua' } },
  })
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add({ 'https://github.com/rafamadriz/friendly-snippets' }) end)

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- now_if_args(function()
--   add({ 'https://github.com/mason-org/mason.nvim' })
--   require('mason').setup()
-- end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
-- Config.now(function()
--  -- Install only those that you need
--  add({
--    'https://github.com/sainnhe/everforest',
--    'https://github.com/Shatur/neovim-ayu',
--    'https://github.com/ellisonleao/gruvbox.nvim',
--  })
--
--   -- Enable only one
--   vim.cmd('color everforest')
-- end)
