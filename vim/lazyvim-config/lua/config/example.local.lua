-- Copy this file to lua/config/local.lua (gitignored) to customize the
-- lazy.nvim config for this machine. The function receives the LazyConfig
-- table and must return a LazyConfig (typically the same table, modified).

--- @param cfg LazyConfig
--- @return LazyConfig
return function(cfg)
  --- @type LazySpecImport[]
  local spec = cfg.spec --[[@as LazySpecImport[] ]]
  -- insert extra before user plugins, after lazyvim extras
  local extras_insert_idx = #spec - 1
  for i, entry in ipairs(spec) do
    if entry.import == "plugins" then
      extras_insert_idx = i
      break
    end
  end
  table.insert(spec, extras_insert_idx, { import = "lazyvim.plugins.extras.ai.copilot-chat" })
  return cfg
end
