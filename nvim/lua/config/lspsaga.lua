local saga = require 'lspsaga'
saga.init_lsp_saga {
    code_action_prompt = {
        enable = false,
    },
    use_saga_diagnostic_sign = false
}

saga.init_lsp_saga()
