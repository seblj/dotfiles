---------- LANGUAGE SERVERS ----------

return {
    volar = {
        init_options = {
            typescript = {
                serverPath = "/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js",
            },
        },
    },

    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
            },
        },
    },

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
