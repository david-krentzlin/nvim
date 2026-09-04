require('mini.extra').setup()

local original_lsp = MiniExtra.pickers.lsp
local options
MiniExtra.pickers.lsp = function(opts) options = opts end

Config.lsp_references()

assert(vim.deep_equal(options, { scope = 'references' }))

MiniExtra.pickers.lsp = original_lsp
