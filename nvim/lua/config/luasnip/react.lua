local utils = require('config.luasnip.utils')
local make = utils.make
local filename = utils.filename
local ls = require('luasnip')
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

local M = {}

local react_component = fmt(
    [[
        import React from 'react';
        const {filename} = () => {{
        {tab}{insert}
        }}

        export default {filename};
    ]],
    {
        insert = i(0),
        filename = f(filename, {}),
        tab = '\t',
    }
)

M.typescriptreact = make({
    component = vim.deepcopy(react_component),
})

M.javascriptreact = make({
    component = vim.deepcopy(react_component),
})

return M
