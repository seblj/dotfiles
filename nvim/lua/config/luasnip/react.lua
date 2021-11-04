local utils = require('config.luasnip.utils')
local make = utils.make
local filename = utils.filename
local ls = require('luasnip')
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

local M = {}

local react_component = {
    t({ "import React from 'react';", '', 'const ' }),
    f(filename, {}),
    t({ ' = () => {', '\t' }),
    i(0),
    t({ '', '};', '', 'export default ' }),
    f(filename, {}),
    t({ ';' }),
}

M.typescriptreact = make({
    component = react_component,
})

M.javascriptreact = {
    component = react_component,
}

return M
