local actions = require('lir.actions')

require'nvim-web-devicons'.setup({
    default = true,
    override = {
        lir_folder_icon = {
            icon = "",
            color = "#7ebae4",
            name = "LirFolderNode"
        },
    }
})

require('lir').setup {
    show_hidden_files = true,
    devicons_enable = true,

    mappings = {
        ['<C-x>']   = actions.split,
        ['<C-v>']   = actions.vsplit,
        ['<C-t>']   = actions.tabedit,
        ['<CR>']    = actions.edit,
        ['..']      = actions.up,
        ['N']       = actions.newfile,
        ['M']       = actions.mkdir,
        ['R']       = actions.rename,
        ['Y']       = actions.yank_path,
        ['D']       = actions.delete,
        ['@']       = actions.cd,
    },
    hide_cursor = true,
}
