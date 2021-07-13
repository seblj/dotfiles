local augroup = require('seblj.utils').augroup
if vim.fn.executable('stylua') == 1 then
    augroup('StyLua', {
        event = 'BufWritePre',
        pattern = '<buffer>',
        modifier = 'silent!',
        command = require('seblj.stylua').format,
    })
end
