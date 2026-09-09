local TEST = require('overseer').TAG.TEST

local function find_project_file(opts, filename)
  return vim.fs.find(filename, { upward = true, path = opts.dir, type = 'file' })[1]
end

local function task(name, cmd, cwd)
  return {
    name = name,
    tags = { TEST },
    builder = function()
      return { cmd = cmd, cwd = cwd }
    end,
  }
end

return {
  generator = function(opts)
    local templates = {}

    if opts.filetype == 'go' then
      local go_mod = find_project_file(opts, 'go.mod')
      if go_mod then
        local root = vim.fs.dirname(go_mod)
        table.insert(templates, task('Go: test package', { 'go', 'test', '.' }, opts.dir))
        table.insert(templates, task('Go: test project', { 'go', 'test', './...' }, root))
      end
    elseif opts.filetype == 'ruby' then
      local gemfile = find_project_file(opts, 'Gemfile')
      if gemfile then
        local root = vim.fs.dirname(gemfile)
        table.insert(templates, task('Ruby: test RSpec suite', { 'bundle', 'exec', 'rspec' }, root))
        table.insert(templates, task('Ruby: test Minitest suite', { 'bundle', 'exec', 'rake', 'test' }, root))
      end
    elseif opts.filetype == 'scala' or opts.filetype == 'sbt' then
      local build_file = find_project_file(opts, 'build.sbt')
      if build_file then
        table.insert(templates, task('Scala: sbt test', { 'sbt', 'test' }, vim.fs.dirname(build_file)))
      end
    end

    return templates
  end,
}
