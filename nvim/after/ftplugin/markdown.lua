-- syntax off in html.vim affects markdown.
-- Isn't any good markdown-parser yet, so turn on the syntax for markdown
vim.cmd('syntax on')

-- opt_local doesn't behave like I want for spell
vim.cmd('setlocal spell')
