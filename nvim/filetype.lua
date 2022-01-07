vim.filetype.add({
    extension = {
        conf = 'conf',
        ts = 'typescript',
    },
    filename = {
        ['.gitconfig.local'] = 'gitconfig',
        ['.gitignore_global'] = 'gitignore',
    },
})
