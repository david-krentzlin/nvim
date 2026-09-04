require('mini.jump2d').setup()

local mapping = vim.fn.maparg('gw', 'n', false, true)
assert(mapping.desc == 'Jump to word')

local original_start = MiniJump2d.start
local options
MiniJump2d.start = function(opts) options = opts end

mapping.callback()

assert(options == MiniJump2d.builtin_opts.word_start)
MiniJump2d.start = original_start
