-- LSP policy =================================================================

local now_if_args = Config.now_if_args

local function has_chart_root(path)
  return #vim.fs.find('Chart.yaml', { path = vim.fs.dirname(path), upward = true }) > 0
end

Config.lsp_filetype = function(path)
  if path:match('%.gotmpl$') then
    return has_chart_root(path) and 'helm' or 'gotmpl'
  end
  if path:match('/templates/[^/]+$') and has_chart_root(path) then return 'helm' end
end

now_if_args(function()
  vim.filetype.add({
    extension = { gotmpl = 'gotmpl', helm = 'helm' },
    pattern = {
      ['.*/templates/.*'] = function(path) return Config.lsp_filetype(path) end,
      ['.*%.yaml%.gotmpl'] = function(path) return Config.lsp_filetype(path) end,
      ['.*%.yml%.gotmpl'] = function(path) return Config.lsp_filetype(path) end,
      ['.*%.json%.gotmpl'] = function(path) return Config.lsp_filetype(path) end,
    },
  })

  vim.lsp.enable({
    'lua_ls',
    'ruby_lsp',
    'gopls',
    'helm_ls',
    'yamlls',
    'jsonls',
    'zk',
    'scls',
    'rust_analyzer',
    'bashls',
    'html',
    'expert',
  })

  local metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = metals_group,
    pattern = { 'scala', 'sbt', 'java' },
    callback = function()
      local ok, metals = pcall(require, 'metals')
      if not ok then
        vim.notify('nvim-metals is not installed; restart Neovim after vim.pack completes', vim.log.levels.WARN)
        return
      end
      local config = metals.bare_config()
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
      config = vim.tbl_deep_extend(
        'force', config, dofile(vim.fn.stdpath('config') .. '/after/lsp/metals.lua')
      )
      metals.initialize_or_attach(config)
    end,
  })
end)

Config.lsp_format_client = {
  bash = 'bashls',
  elixir = 'expert',
  go = 'gopls',
  json = 'jsonls',
  ruby = 'ruby_lsp',
  rust = 'rust_analyzer',
  scala = 'metals',
}

Config.lsp_format = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local client_name = Config.lsp_format_client[vim.bo[bufnr].filetype]
  if not client_name then return end
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return client.name == client_name and client:supports_method('textDocument/formatting')
    end,
  })
end

Config.lsp_references = function()
  require('mini.extra').pickers.lsp({ scope = 'references' })
end

Config.enable_gopls_inlay_hints = function(client, bufnr)
  if client.name ~= 'gopls' or not client:supports_method('textDocument/inlayHint') then
    return false
  end
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  return true
end

now_if_args(function()
  local format_group = vim.api.nvim_create_augroup('lsp-format-on-save', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = format_group,
    pattern = { '*.go', '*.rs', '*.scala', '*.rb', '*.json', '*.sh', '*.bash', '*.ex', '*.exs' },
    callback = function(ev) Config.lsp_format(ev.buf) end,
  })

  Config.new_autocmd('LspAttach', nil, function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then Config.enable_gopls_inlay_hints(client, ev.buf) end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map('n', 'gd', vim.lsp.buf.definition, 'Definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Declaration')
    map('n', 'gT', vim.lsp.buf.type_definition, 'Type definition')
    map('n', 'gi', vim.lsp.buf.implementation, 'Implementation')
    map('n', 'gr', Config.lsp_references, 'References')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', 'gK', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<Leader>a', vim.lsp.buf.code_action, 'Code action')
    map('n', '<Leader>h', Config.lsp_references, 'References')
    map('n', '<Leader>k', vim.lsp.buf.hover, 'Hover')
    map('n', '<Leader>r', vim.lsp.buf.rename, 'Rename')
    map('n', '<Leader>S', function()
      vim.ui.input({ prompt = 'Workspace symbols: ' }, function(query)
        if query and query ~= '' then vim.lsp.buf.workspace_symbol(query) end
      end)
    end, 'Workspace symbols')
  end, 'LSP mappings')
end)
