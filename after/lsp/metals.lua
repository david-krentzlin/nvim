return {
  on_attach = function() require('metals').setup_dap() end,
  init_options = { statusBarProvider = 'on' },
  settings = {
    showImplicitArguments = true,
    showInferredType = false,
    superMethodLensesEnabled = true,
  },
}
