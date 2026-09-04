local function project_has_tool(root, tool)
  if vim.fn.executable(root .. '/bin/' .. tool) == 1 then return true end
  local lockfile = root .. '/Gemfile.lock'
  if vim.fn.filereadable(lockfile) == 0 then return false end
  return vim.fn.join(vim.fn.readfile(lockfile), '\n'):find('\n    ' .. tool .. ' ') ~= nil
end

return {
  cmd = { 'ruby-lsp' },
  root_markers = { 'Gemfile', '.git' },
  on_new_config = function(config, root)
    local settings = vim.deepcopy(config.settings or {})
    settings.rubyLsp = settings.rubyLsp or {}
    if project_has_tool(root, 'rubyfmt') then settings.rubyLsp.formatter = 'rubyfmt' end
    if project_has_tool(root, 'standardrb') then settings.rubyLsp.linters = { 'standardrb' } end
    config.settings = settings
  end,
}
