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
  assert(Config.aerial_config.icons[kind] == MiniIcons.get('lsp', kind))
end

local outline_shortcut = vim.fn.maparg('<Space>s', 'n', false, true)
assert(outline_shortcut.desc == 'Toggle outline')
assert(outline_shortcut.rhs == '<Cmd>AerialToggle<CR>')
assert(vim.fn.maparg('{', 'n', false, true).rhs ~= '<Cmd>AerialPrev<CR>')
assert(vim.fn.maparg('}', 'n', false, true).rhs ~= '<Cmd>AerialNext<CR>')
