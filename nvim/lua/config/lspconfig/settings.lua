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

    volar = {
        init_options = {
            vue = {
                hybridMode = false,
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
}
