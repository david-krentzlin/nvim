local config = table.concat(vim.fn.readfile('plugin/40_plugins.lua'), '\n')

assert(config:find("version = vim.version.range%('2%.%*'%)"))
assert(config:find("vim.keymap.set%('n', '<A%-n>', '<Cmd>cnext<CR>'"))
assert(config:find("vim.keymap.set%('n', '<A%-p>', '<Cmd>cprevious<CR>'"))
assert(config:find("vim.keymap.set%('n', '<Leader>q', function%(%) require%('quicker'%).toggle%(%)"))
assert(config:find("vim.keymap.set%('n', '<Leader>%$%$', '<Cmd>OverseerRun<CR>'"))
assert(config:find("vim.keymap.set%('n', '<Leader>%$t', '<Cmd>OverseerToggle<CR>'"))
assert(not config:find('OverseerTaskAction'))
