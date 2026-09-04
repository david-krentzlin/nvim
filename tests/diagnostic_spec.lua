vim.wait(100)

local signs = vim.diagnostic.config().signs
assert(vim.deep_equal(signs.text, { ERROR = '●', WARN = '●' }))
