vim.filetype.add({
    extension = {
        conf = 'conf',
        ['local'] = 'gitconfig',
    },
    filename = {
        ['.gitconfig.local'] = 'gitconfig',
        ['.gitignore_global'] = 'gitignore',
    },
})
