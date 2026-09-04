local function map(mode, lhs)
  local result = vim.fn.maparg(lhs, mode, false, true)
  assert(type(result) == 'table' and result.lhs ~= '', mode .. ' ' .. lhs)
  return result
end

for _, lhs in ipairs({
  'mm', 'ma', 'mi', 'mig', 'mg',
  '<Space>e', '<Space>.', '<Space>f', '<Space>F', '<Space>b', '<Space>j',
  '<Space>g', '<Space>o', '<Space>d', '<Space>D', '<Space>w', '<Space>c',
  '<Space>C', '<Space>p', '<Space>P', '<Space>y', '<Space>Y', '<Space>R',
  '<Space>/', '<Space>?', '<Space>*',
}) do
  assert(map('n', lhs).desc ~= nil, lhs .. ' has no description')
end

for _, lhs in ipairs({ '<Space>c', '<Space>C', '<Space>p', '<Space>P', '<Space>y', '<Space>R' }) do
  assert(map('x', lhs).desc ~= nil, lhs .. ' has no description')
end

for _, lhs in ipairs({ '<Space>mj', '<Space>mk', '<Space>mn', '<Space>mN', '<Space>ms', '<Space>mS', '<Space>mq', '<Space>mc' }) do
  assert(map('n', lhs).desc ~= nil, lhs .. ' has no description')
  assert(map('x', lhs).desc ~= nil, lhs .. ' has no description')
end

assert(vim.fn.maparg('<Left>', 'i') == '')
assert(vim.fn.maparg('<Right>', 'i') == '')
assert(vim.fn.maparg('<Space>mf', 'n') == '')
assert(vim.fn.maparg('<Space>mr', 'n') == '')
assert(vim.fn.maparg('<Space>mt', 'n') == '')
