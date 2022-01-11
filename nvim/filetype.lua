vim.filetype.add({
    extension = {
        conf = 'conf',
    },
    filename = {
        ['.gitconfig.local'] = 'gitconfig',
        ['.gitignore_global'] = 'gitignore',
    },
})
