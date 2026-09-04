local expected_kinds = {
  'Class',
  'Constructor',
  'Enum',
  'Function',
  'Interface',
  'Module',
  'Method',
  'Struct',
}

assert(vim.deep_equal(Config.aerial_kinds, expected_kinds))
assert(vim.deep_equal(Config.aerial_config.backends, { 'treesitter', 'lsp', 'markdown', 'man' }))
assert(not Config.aerial_config.open_automatic)
assert(Config.aerial_config.autojump)
assert(Config.aerial_config.highlight_closest)
assert(Config.aerial_config.highlight_on_hover)
assert(Config.aerial_config.highlight_mode == 'last')
assert(Config.aerial_config.layout.default_direction == 'left')
assert(Config.aerial_config.layout.placement == 'edge')
assert(Config.aerial_config.layout.min_width >= 28)

for _, kind in ipairs(expected_kinds) do
  assert(type(Config.aerial_config.icons[kind]) == 'string')
end

local outline = vim.fn.maparg('<Space>o', 'n', false, true)
assert(outline.desc == 'Toggle outline')
assert(outline.rhs == '<Cmd>AerialToggle<CR>')
assert(vim.fn.maparg('<Space>s', 'n') ~= '<Cmd>AerialToggle<CR>')
assert(vim.fn.maparg('{', 'n', false, true).rhs ~= '<Cmd>AerialPrev<CR>')
assert(vim.fn.maparg('}', 'n', false, true).rhs ~= '<Cmd>AerialNext<CR>')
