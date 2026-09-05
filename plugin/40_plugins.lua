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

Config.now(function()
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

Config.now(function()
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

-- Multiple cursors ===========================================================

Config.now(function()
  add({ { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' } })

  local mc = require('multicursor-nvim')
  mc.setup()

  -- `multicursor.nvim` adds Insert-mode Left/Right mappings when they are not
  -- already mapped. Keep arrow keys fully unmapped for this configuration.
  vim.keymap.del('i', '<Left>')
  vim.keymap.del('i', '<Right>')

  local modes = { 'n', 'x' }
  local set = function(lhs, rhs, desc)
    vim.keymap.set(modes, '<Leader>m' .. lhs, rhs, { desc = desc })
  end

  set('j', function() mc.lineAddCursor(1) end, 'Cursor below')
  set('k', function() mc.lineAddCursor(-1) end, 'Cursor above')
  set('n', function() mc.matchAddCursor(1) end, 'Next match')
  set('N', function() mc.matchAddCursor(-1) end, 'Previous match')
  set('s', function() mc.matchSkipCursor(1) end, 'Skip next match')
  set('S', function() mc.matchSkipCursor(-1) end, 'Skip previous match')
  set('q', mc.toggleCursor, 'Toggle cursor synchronization')
  set('c', mc.clearCursors, 'Clear cursors')

  mc.addKeymapLayer(function(layer_set)
    layer_set(modes, '<Leader>mh', mc.prevCursor, { desc = 'Previous cursor' })
    layer_set(modes, '<Leader>ml', mc.nextCursor, { desc = 'Next cursor' })
    layer_set(modes, '<Leader>md', mc.deleteCursor, { desc = 'Delete cursor' })
    layer_set('n', '<Esc>', mc.clearCursors, { desc = 'Clear cursors' })
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
