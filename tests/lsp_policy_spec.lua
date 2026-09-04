local root = vim.fn.tempname()
vim.fn.mkdir(root .. '/chart/templates', 'p')
vim.fn.mkdir(root .. '/plain', 'p')
vim.fn.mkdir(root .. '/plain/templates', 'p')
vim.fn.mkdir(root .. '/ruby/lib', 'p')
vim.fn.writefile({ 'apiVersion: v2', 'name: test', 'version: 0.1.0' }, root .. '/chart/Chart.yaml')
vim.fn.writefile({ '{{ .Values.name }}' }, root .. '/chart/templates/deploy.yaml')
vim.fn.writefile({ '{{ .Values.name }}' }, root .. '/chart/templates/deploy.yaml.gotmpl')
vim.fn.writefile({ '{{ .Values.name }}' }, root .. '/plain/deploy.yaml.gotmpl')
vim.fn.writefile({ '{{ .Title }}' }, root .. '/chart/templates/index.html.gotmpl')
vim.fn.writefile({ '{{ .Title }}' }, root .. '/plain/index.html.gotmpl')
vim.fn.writefile({ 'key: value' }, root .. '/plain/plain.yaml')
vim.fn.writefile({ 'key: value' }, root .. '/plain/templates/plain.yaml')
vim.fn.writefile({ '{{ .Values.name }}' }, root .. '/plain/chart.helm')
vim.fn.writefile({ 'source "https://rubygems.org"' }, root .. '/ruby/Gemfile')
vim.fn.writefile({ 'class Example; end' }, root .. '/ruby/lib/example.rb')

local function filetype(path)
  return vim.filetype.match({ filename = path })
end

assert(vim.deep_equal(Config.treesitter_languages, {
  'lua',
  'vimdoc',
  'markdown',
  'markdown_inline',
  'bash',
  'elixir',
  'go',
  'gotmpl',
  'helm',
  'html',
  'json',
  'ruby',
  'rust',
  'scala',
  'yaml',
}))

assert(filetype(root .. '/chart/templates/deploy.yaml') == 'helm')
assert(filetype(root .. '/chart/templates/deploy.yaml.gotmpl') == 'helm')
assert(filetype(root .. '/plain/deploy.yaml.gotmpl') == 'gotmpl')
assert(filetype(root .. '/chart/templates/index.html.gotmpl') == 'helm')
assert(filetype(root .. '/plain/index.html.gotmpl') == 'gotmpl')
assert(filetype(root .. '/plain/plain.yaml') == 'yaml')
assert(filetype(root .. '/plain/templates/plain.yaml') == 'yaml')
assert(filetype(root .. '/plain/chart.helm') == 'helm')
assert(Config.lsp_filetype(root .. '/chart/templates/deploy.yaml') == 'helm')
assert(Config.lsp_filetype(root .. '/plain/deploy.yaml.gotmpl') == 'gotmpl')
assert(vim.lsp.is_enabled('lua_ls'))
assert(vim.lsp.is_enabled('ruby_lsp'))
assert(vim.lsp.is_enabled('gopls'))
assert(vim.lsp.is_enabled('helm_ls'))
assert(vim.lsp.is_enabled('yamlls'))
assert(vim.lsp.is_enabled('jsonls'))
assert(vim.lsp.is_enabled('zk'))
assert(vim.lsp.is_enabled('scls'))
assert(vim.lsp.is_enabled('rust_analyzer'))
assert(vim.lsp.is_enabled('bashls'))
assert(vim.lsp.is_enabled('html'))
assert(vim.lsp.is_enabled('elixirls'))
assert(not vim.lsp.is_enabled('metals'))

local zk = vim.lsp.config.zk
assert(vim.deep_equal(zk.cmd, { 'zk', 'lsp' }))
assert(vim.deep_equal(zk.filetypes, { 'markdown' }))
assert(vim.deep_equal(zk.root_markers, { '.zk' }))

local scls = vim.lsp.config.scls
assert(scls.filetypes[1] == 'markdown')
assert(scls.filetypes[2] == 'org')
assert(vim.deep_equal(scls.root_markers, { '.git' }))
assert(scls.settings.feature_words)
assert(scls.settings.feature_snippets)
assert(scls.settings.snippets_first)
assert(not scls.settings.case_sensitive)
assert(not scls.settings.snippets_inline_by_word_tail)
assert(not scls.settings.feature_unicode_input)
assert(not scls.settings.feature_paths)
assert(not scls.settings.feature_citations)

assert(vim.deep_equal(vim.lsp.config.rust_analyzer.filetypes, { 'rust' }))
assert(vim.tbl_contains(vim.lsp.config.bashls.filetypes, 'bash'))
assert(vim.deep_equal(vim.lsp.config.html.filetypes, { 'html' }))
assert(vim.tbl_contains(vim.lsp.config.elixirls.filetypes, 'elixir'))
assert(vim.deep_equal(vim.lsp.config.elixirls.cmd, { 'elixir-ls' }))
assert(vim.tbl_contains(vim.lsp.config.gopls.filetypes, 'gotmpl'))
assert(not vim.lsp.config.gopls.capabilities.textDocument.completion.completionItem.snippetSupport)
assert(vim.deep_equal(vim.lsp.config.helm_ls.filetypes, { 'helm' }))
assert(vim.deep_equal(vim.lsp.config.yamlls.filetypes, { 'yaml' }))
assert(not vim.tbl_contains(vim.lsp.config.yamlls.filetypes, 'gotmpl'))
assert(vim.deep_equal(vim.lsp.config.ruby_lsp.cmd, { 'ruby-lsp' }))
assert(vim.deep_equal(vim.lsp.config.ruby_lsp.root_markers, { 'Gemfile', '.git' }))
assert(vim.fs.root(root .. '/ruby/lib/example.rb', vim.lsp.config.ruby_lsp.root_markers) == root .. '/ruby')

for _, case in ipairs({ { 'bash', 'bashls' }, { 'rust', 'rust_analyzer' }, { 'elixir', 'elixirls' } }) do
  assert(Config.lsp_format_client[case[1]] == case[2])
end

local original_enable = vim.lsp.inlay_hint.enable
local enabled
vim.lsp.inlay_hint.enable = function(value, options)
  enabled = { value = value, options = options }
end
assert(Config.enable_gopls_inlay_hints({
  name = 'gopls',
  supports_method = function(_, method) return method == 'textDocument/inlayHint' end,
}, 42))
assert(enabled.value and enabled.options.bufnr == 42)
assert(not Config.enable_gopls_inlay_hints({
  name = 'gopls',
  supports_method = function() return false end,
}, 42))
assert(not Config.enable_gopls_inlay_hints({
  name = 'yamlls',
  supports_method = function() return true end,
}, 42))
vim.lsp.inlay_hint.enable = original_enable

local original_start = vim.treesitter.start
local started_bufnr
vim.treesitter.start = function(bufnr)
  started_bufnr = bufnr
  error('parser unavailable')
end
local go_bufnr = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(go_bufnr, root .. '/missing-parser.go')
assert(pcall(vim.api.nvim_buf_call, go_bufnr, function() vim.bo.filetype = 'go' end))
assert(started_bufnr == go_bufnr)
vim.api.nvim_buf_delete(go_bufnr, { force = true })
vim.treesitter.start = original_start

vim.fn.delete(root, 'rf')
