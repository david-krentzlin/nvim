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

local original_start = MiniJump2d.start
local options
MiniJump2d.start = function(opts) options = opts end

mapping.callback()

assert(options == MiniJump2d.builtin_opts.word_start)
MiniJump2d.start = original_start
