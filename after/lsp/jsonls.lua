local has_schemastore, schemastore = pcall(require, 'schemastore')

return {
  settings = {
    json = {
      schemas = has_schemastore and schemastore.json.schemas() or {},
      validate = { enable = true },
    },
  },
}
