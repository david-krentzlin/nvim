require('mini.jump2d').setup()

local mapping = vim.fn.maparg('gw', 'n', false, true)
assert(mapping.desc == 'Jump to word')

local run_commands_clue = vim.tbl_filter(function(clue)
  return clue.mode == 'n' and clue.keys == '<Leader>$' and clue.desc == '+Run commands'
end, Config.leader_group_clues)
assert(#run_commands_clue == 1)

local tests_clue = vim.tbl_filter(function(clue)
  return clue.mode == 'n' and clue.keys == '<LocalLeader>t' and clue.desc == '+Tests'
end, Config.leader_group_clues)
assert(#tests_clue == 1)

local notes_clue = vim.tbl_filter(function(clue)
  return clue.mode == 'n' and clue.keys == '<Leader>n' and clue.desc == '+Notes'
end, Config.leader_group_clues)
assert(#notes_clue == 1)

for _, key in ipairs({ 'nc', 'nn', 'no', 'nf' }) do
  local note_mapping = vim.fn.maparg('<Space>' .. key, 'n', false, true)
  assert(note_mapping.desc:find('note', 1, true) or note_mapping.desc == 'Search notes')
end

local visual_note_search = vim.fn.maparg('<Space>nf', 'x', false, true)
assert(visual_note_search.desc == 'Search selected notes')

local original_start = MiniJump2d.start
local options
MiniJump2d.start = function(opts) options = opts end

mapping.callback()

assert(options == MiniJump2d.builtin_opts.word_start)
MiniJump2d.start = original_start
