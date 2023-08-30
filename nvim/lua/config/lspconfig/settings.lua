---------- LANGUAGE SERVERS ----------

return {
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
            },
        },
    },

    -- tsserver = {
    --     init_options = {
    --         preferences = {
    --             importModuleSpecifierPreference = "relative",
    --             importModuleSpecifierEnding = "minimal",
    --         },
    --     },
    -- },

    jsonls = {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
    },

    omnisharp = {
        handlers = {
            ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
    },
}
