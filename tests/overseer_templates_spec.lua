assert(vim.wait(1000, function() return package.loaded.overseer ~= nil end), 'Overseer did not load')

local overseer = require('overseer')
local template = require('overseer.template')

local mapping = vim.fn.maparg(',tt', 'n', false, true)
assert(mapping.desc == 'Run test task')
local local_leader_trigger = vim.tbl_filter(function(trigger)
  return trigger.mode == 'n' and trigger.keys == '<LocalLeader>'
end, MiniClue.config.triggers)
assert(#local_leader_trigger == 1)

local templates_for = function(dir, filetype)
  local templates
  template.list({ dir = dir, filetype = filetype, tags = { overseer.TAG.TEST } }, function(result)
    templates = result
  end)
  assert(vim.wait(1000, function() return templates ~= nil end), 'Timed out loading Overseer test templates')

  return vim.tbl_map(function(task) return task.name end, templates)
end

local root = vim.fn.getcwd() .. '/tests/fixtures'
local go = templates_for(root .. '/go', 'go')
assert(vim.tbl_contains(go, 'Go: test package'))
assert(vim.tbl_contains(go, 'Go: test project'))

local ruby = templates_for(root .. '/ruby', 'ruby')
assert(vim.tbl_contains(ruby, 'Ruby: test RSpec suite'))
assert(vim.tbl_contains(ruby, 'Ruby: test Minitest suite'))

local scala = templates_for(root .. '/scala', 'scala')
assert(vim.tbl_contains(scala, 'Scala: sbt test'))
