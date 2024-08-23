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

    tsserver = {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = string.format(
                        "%s/node_modules/@vue/language-server",
                        require("mason-registry").get_package("vue-language-server"):get_install_path()
                    ),
                    languages = { "vue" },
                },
            },
            -- preferences = {
            --     importModuleSpecifierPreference = "relative",
            --     importModuleSpecifierEnding = "minimal",
            -- },
        },
    },

    jsonls = {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
    },
}
