local has_schemastore, schemastore = pcall(require, 'schemastore')

return {
  filetypes = { 'yaml' },
  settings = {
    yaml = {
      completion = true,
      format = { enable = true, singleQuote = false, bracketSpacing = true },
      hover = true,
      schemaStore = { enable = true, url = '' },
      schemas = has_schemastore and schemastore.yaml.schemas() or {},
      validate = true,
    },
  },
}
