-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
--
-- This file contains definitions of custom general and Leader mappings.

-- General mappings ===========================================================

-- Use this section to add custom general mappings. See `:h vim.keymap.set()`.

-- An example helper to create a Normal mode mapping
local nmap = function(lhs, rhs, desc)
  -- See `:h vim.keymap.set()`
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
nmap('[p', '<Cmd>exe "iput! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "iput "  . v:register<CR>', 'Paste Below')

-- Helix-style match prefix. Keep built-in `a`/`i` textobjects intact.
nmap('mm', '%', 'Matching bracket')
vim.keymap.set('n', 'ma', 'va', { remap = true, desc = 'Around textobject' })
vim.keymap.set('n', 'mi', 'vi', { remap = true, desc = 'Inside textobject' })
local select_git_hunk = function()
  local ok = pcall(MiniDiff.textobject)
  if not ok then vim.notify('No Git hunk under cursor', vim.log.levels.INFO) end
end
nmap('mig', select_git_hunk, 'Git hunk textobject')

-- `mg` selects and overlays current hunk. Press it again in Visual mode for
-- Git range history/details through `MiniGit.show_at_cursor()`.
local show_hunk_details = function()
  MiniDiff.toggle_overlay()
  select_git_hunk()
end
nmap('mg', show_hunk_details, 'Git hunk details')
vim.keymap.set('x', 'mg', '<Cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'Git hunk history' })

-- Many general mappings are created by 'mini.basics'. See 'plugin/30_mini.lua'

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading. Consider preserving this or remove `-- stylua` lines to autoformat.

-- Space mappings =============================================================

-- Keep Space mode small and direct, matching the daily Helix contract. Groups
-- exist only where an action must have a second key: multicursors and windows.
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>m', desc = '+Cursors' },
  { mode = 'x', keys = '<Leader>m', desc = '+Cursors' },
  { mode = 'n', keys = '<Leader>w', desc = '+Windows' },
}

local nmap_leader = function(key, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. key, rhs, { desc = desc })
end
local xmap_leader = function(key, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. key, rhs, { desc = desc })
end

local current_directory = function()
  local path = vim.api.nvim_buf_get_name(0)
  return path == '' and vim.fn.getcwd() or vim.fs.dirname(path)
end

local pick_current_directory_files = function()
  MiniPick.builtin.files(nil, { source = { cwd = current_directory() } })
end

local toggle_current_line_comment = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  MiniComment.toggle_lines(line, line)
end

local toggle_visual_line_comments = function()
  local first = vim.fn.getpos('v')[2]
  local last = vim.api.nvim_win_get_cursor(0)[1]
  MiniComment.toggle_lines(math.min(first, last), math.max(first, last))
end

-- Oil follows Helix's direct Space-mode explorer mappings.
local open_oil_parent = function()
  require('oil').open(current_directory())
end

nmap_leader('e', '<Cmd>Oil<CR>', 'Oil project root')
nmap_leader('.', '<Cmd>Oil %:p:h<CR>', 'Oil file directory')
nmap('-', open_oil_parent, 'Oil parent directory')

nmap_leader('f', '<Cmd>Pick files<CR>', 'Files at project root')
nmap_leader('F', pick_current_directory_files, 'Files in current directory')
nmap_leader('b', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('j', '<Cmd>Pick list scope="jump"<CR>', 'Jumplist')
nmap_leader('g', '<Cmd>Pick git_files scope="modified"<CR>', 'Changed files')
nmap_leader('o', '<Cmd>AerialToggle<CR>', 'Toggle outline')
nmap_leader('d', '<Cmd>Pick diagnostic scope="current"<CR>', 'Document diagnostics')
nmap_leader('D', '<Cmd>Pick diagnostic scope="all"<CR>', 'Workspace diagnostics')
nmap_leader('w', '<C-w>', 'Window actions')
nmap_leader('c', toggle_current_line_comment, 'Toggle line comment')
-- MiniComment only supports line comments. Keep Helix's `C` binding as the
-- closest equivalent instead of advertising unavailable block comments.
nmap_leader('C', toggle_current_line_comment, 'Toggle line comment (no block support)')
nmap_leader('p', '"+p', 'Paste after from clipboard')
nmap_leader('P', '"+P', 'Paste before from clipboard')
nmap_leader('y', '"+y', 'Yank to clipboard')
nmap_leader('Y', '"+Y', 'Yank line to clipboard')
nmap_leader('R', '"_d"+P', 'Replace with clipboard')
nmap_leader('/', '<Cmd>Pick grep_live<CR>', 'Workspace grep')
nmap_leader('?', '<Cmd>Pick commands<CR>', 'Command picker')
nmap_leader('*', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Workspace grep current word')

xmap_leader('c', toggle_visual_line_comments, 'Toggle selection line comments')
xmap_leader('C', toggle_visual_line_comments, 'Toggle selection line comments (no block support)')
xmap_leader('p', '"+p', 'Paste after from clipboard')
xmap_leader('P', '"+P', 'Paste before from clipboard')
xmap_leader('y', '"+y', 'Yank to clipboard')
xmap_leader('R', '"_d"+P', 'Replace with clipboard')
