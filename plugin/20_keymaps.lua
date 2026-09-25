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

-- Match and Git hunk mappings. Textobjects use Neovim's native `a`/`i` grammar.
nmap('mm', '%', 'Matching bracket')
nmap('gw', function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end, 'Jump to word')
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
-- exist only where an action must have a second key.
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>m', desc = '+Cursors' },
  { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
  { mode = 'n', keys = '<Leader>t', desc = '+Run commands' },
  { mode = 'n', keys = '<LocalLeader>d', desc = '+Debug' },
  { mode = 'n', keys = '<LocalLeader>t', desc = '+Tests' },
  { mode = 'x', keys = '<Leader>m', desc = '+Cursors' },
  { mode = 'n', keys = '<Leader>w', desc = '+Windows' },
}

Config.mini_ai_clues = {
  { mode = { 'o', 'x' }, keys = 'a(', desc = 'Around parentheses' },
  { mode = { 'o', 'x' }, keys = 'a[', desc = 'Around brackets' },
  { mode = { 'o', 'x' }, keys = 'a{', desc = 'Around braces' },
  { mode = { 'o', 'x' }, keys = 'a<', desc = 'Around angle brackets' },
  { mode = { 'o', 'x' }, keys = 'ab', desc = 'Around any bracket pair' },
  { mode = { 'o', 'x' }, keys = 'a"', desc = 'Around double quotes' },
  { mode = { 'o', 'x' }, keys = "a'", desc = 'Around single quotes' },
  { mode = { 'o', 'x' }, keys = 'a`', desc = 'Around backticks' },
  { mode = { 'o', 'x' }, keys = 'aq', desc = 'Around any quote' },
  { mode = { 'o', 'x' }, keys = 'aa', desc = 'Around argument' },
  { mode = { 'o', 'x' }, keys = 'af', desc = 'Around function call' },
  { mode = { 'o', 'x' }, keys = 'at', desc = 'Around tag' },
  { mode = { 'o', 'x' }, keys = 'aB', desc = 'Around buffer' },
  { mode = { 'o', 'x' }, keys = 'aC', desc = 'Around class' },
  { mode = { 'o', 'x' }, keys = 'aF', desc = 'Around function definition' },
  { mode = { 'o', 'x' }, keys = 'aK', desc = 'Around block' },
  { mode = { 'o', 'x' }, keys = 'aL', desc = 'Around loop' },
  { mode = { 'o', 'x' }, keys = 'aO', desc = 'Around conditional' },
  { mode = { 'o', 'x' }, keys = 'aP', desc = 'Around parameter' },
  { mode = { 'o', 'x' }, keys = 'aX', desc = 'Around comment' },
  { mode = { 'o', 'x' }, keys = 'a?', desc = 'Around prompted textobject' },
  { mode = { 'o', 'x' }, keys = 'i(', desc = 'Inside parentheses' },
  { mode = { 'o', 'x' }, keys = 'i[', desc = 'Inside brackets' },
  { mode = { 'o', 'x' }, keys = 'i{', desc = 'Inside braces' },
  { mode = { 'o', 'x' }, keys = 'i<', desc = 'Inside angle brackets' },
  { mode = { 'o', 'x' }, keys = 'ib', desc = 'Inside any bracket pair' },
  { mode = { 'o', 'x' }, keys = 'i"', desc = 'Inside double quotes' },
  { mode = { 'o', 'x' }, keys = "i'", desc = 'Inside single quotes' },
  { mode = { 'o', 'x' }, keys = 'i`', desc = 'Inside backticks' },
  { mode = { 'o', 'x' }, keys = 'iq', desc = 'Inside any quote' },
  { mode = { 'o', 'x' }, keys = 'ia', desc = 'Inside argument' },
  { mode = { 'o', 'x' }, keys = 'if', desc = 'Inside function call' },
  { mode = { 'o', 'x' }, keys = 'it', desc = 'Inside tag' },
  { mode = { 'o', 'x' }, keys = 'iB', desc = 'Inside buffer' },
  { mode = { 'o', 'x' }, keys = 'iC', desc = 'Inside class' },
  { mode = { 'o', 'x' }, keys = 'iF', desc = 'Inside function definition' },
  { mode = { 'o', 'x' }, keys = 'iK', desc = 'Inside block' },
  { mode = { 'o', 'x' }, keys = 'iL', desc = 'Inside loop' },
  { mode = { 'o', 'x' }, keys = 'iO', desc = 'Inside conditional' },
  { mode = { 'o', 'x' }, keys = 'iP', desc = 'Inside parameter' },
  { mode = { 'o', 'x' }, keys = 'iX', desc = 'Inside comment' },
  { mode = { 'o', 'x' }, keys = 'i?', desc = 'Inside prompted textobject' },
  { mode = { 'n' }, keys = 'sa', desc = 'Surround add' },
  { mode = { 'n' }, keys = 'sr', desc = 'Surround replace' },
  { mode = { 'n' }, keys = 'sd', desc = 'Surround delete' },
  { mode = { 'n' }, keys = 'sh', desc = 'Surround highlight' },
  { mode = { 'n' }, keys = 'sf', desc = 'Surround find' },
  { mode = { 'n' }, keys = 'sF', desc = 'Surround find backwards' },
  { mode = { 'n', 'x' }, keys = 'ms', desc = 'Surround add (Helix)' },
  { mode = { 'n' }, keys = 'mr', desc = 'Surround replace (Helix)' },
  { mode = { 'n' }, keys = 'md', desc = 'Surround delete (Helix)' },
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

local notebook_directory = function()
  local path = vim.env.ZK_NOTEBOOK_DIR
  if path and path ~= '' then return path end

  vim.notify('Set ZK_NOTEBOOK_DIR before using note mappings', vim.log.levels.ERROR)
end

local open_scratch_note = function()
  local notebook = notebook_directory()
  if not notebook then return end

  local scratch = vim.fs.joinpath(notebook, 'scratch.md')
  if vim.fn.filereadable(scratch) == 0 then
    vim.notify('Scratch note does not exist: ' .. scratch, vim.log.levels.ERROR)
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(scratch))
  vim.cmd.normal({ args = { 'G' }, bang = true })
end

local zk_command = function(name, options)
  local notebook = notebook_directory()
  if not notebook then return end

  options = vim.tbl_extend('force', { notebook_path = notebook }, options or {})
  require('zk.commands').get(name)(options)
end

local search_notes = function()
  vim.ui.input({ prompt = 'Search notes: ' }, function(query)
    if query and query ~= '' then
      zk_command('ZkNotes', { sort = { 'modified' }, match = { query } })
    end
  end)
end

local create_named_note = function()
  vim.ui.input({ prompt = 'Note title: ' }, function(title)
    if title and title ~= '' then zk_command('ZkNew', { title = title }) end
  end)
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
nmap_leader('nc', open_scratch_note, 'Open scratch note')
nmap_leader('nn', create_named_note, 'Create named note')
nmap_leader('no', function() zk_command('ZkNotes', { sort = { 'modified' } }) end, 'Browse notes')
nmap_leader('nf', search_notes, 'Search notes')
nmap_leader('s', '<Cmd>AerialToggle<CR>', 'Toggle outline')
nmap_leader('d', '<Cmd>Pick diagnostic scope="current"<CR>', 'Document diagnostics')
nmap_leader('D', '<Cmd>Pick diagnostic scope="all"<CR>', 'Workspace diagnostics')
nmap_leader('ww', '<Cmd>wincmd w<CR>', 'Next window')
nmap_leader('wv', '<Cmd>vsplit<CR>', 'Vertical split')
nmap_leader('ws', '<Cmd>split<CR>', 'Horizontal split')
nmap_leader('wh', '<Cmd>wincmd h<CR>', 'Focus left window')
nmap_leader('wj', '<Cmd>wincmd j<CR>', 'Focus lower window')
nmap_leader('wk', '<Cmd>wincmd k<CR>', 'Focus upper window')
nmap_leader('wl', '<Cmd>wincmd l<CR>', 'Focus right window')
nmap_leader('wq', '<Cmd>close<CR>', 'Close window')
nmap_leader('wo', '<Cmd>only<CR>', 'Only current window')
nmap_leader('wH', '<Cmd>wincmd H<CR>', 'Move window left')
nmap_leader('wJ', '<Cmd>wincmd J<CR>', 'Move window down')
nmap_leader('wK', '<Cmd>wincmd K<CR>', 'Move window up')
nmap_leader('wL', '<Cmd>wincmd L<CR>', 'Move window right')
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
xmap_leader('nf', '<Cmd>ZkMatch<CR>', 'Search selected notes')
