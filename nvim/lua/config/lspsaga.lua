---------- LSPSAGA CONFIG ----------

require('lspsaga').init_lsp_saga {
    code_action_prompt = {
        enable = false
    },
    code_action_keys = {
        quit = '<esc>',exec = '<CR>'
    },
    use_saga_diagnostic_sign = false,
    border_style = "round"
}
