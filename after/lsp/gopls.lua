return {
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      analyses = {
        shadow = true,
        unusedparams = true,
        unusedvariable = true,
        useany = true,
      },
      codelenses = {
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      semanticTokens = true,
      staticcheck = true,
      templateExtensions = { 'tmpl', 'gotmpl', 'gohtml', 'gotxt' },
    },
  },
}
