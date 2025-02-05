---@class NvimTestRunnerConfig
---@field query string
---@field root? fun(): string | nil
---@field is_test_file? boolean | fun(): boolean

---@class NvimTestRunner
---@field query string
---@field root fun(): string | nil
---@field is_test_file fun(): boolean
local TestRunner = {
    is_test_file = function()
        return true
    end,
    root = function()
        return nil
    end,
}

---@param config NvimTestRunnerConfig
---@return NvimTestRunner
function TestRunner:new(config)
    local o = {}
    setmetatable(o, { __index = self })

    o.is_test_file = config.is_test_file
    o.root = config.root
    o.query = config.query

    return o
end

function TestRunner.find_first_capture(query)
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
    local parsed_query = vim.treesitter.query.parse(lang, query)
    if not parsed_query then
        return {}
    end

    local parser = vim.treesitter.get_parser(0, lang)
    if not parser then
        return {}
    end
    local root = parser:parse()[1]:root()

    for _, node in parsed_query:iter_captures(root, 0, 0, -1) do
        return vim.treesitter.get_node_text(node, 0)
    end

    return {}
end

---@param query string
---@return string[]
function TestRunner.find_nearest_captures(query)
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
    local parsed_query = vim.treesitter.query.parse(lang, query)
    if not parsed_query then
        return {}
    end

    local result = {}
    local curnode = vim.treesitter.get_node()
    while curnode do
        local iter = parsed_query:iter_captures(curnode, 0)
        local capture_id, capture_node = iter()
        if capture_node == curnode and parsed_query.captures[capture_id] == "scope-root" then
            while parsed_query.captures[capture_id] ~= "test-name" do
                capture_id, capture_node = iter()
                if not capture_id then
                    return result
                end
            end
            local name = vim.treesitter.get_node_text(capture_node, 0)
            table.insert(result, 1, name)
        end
        curnode = curnode:parent()
    end
    return result
end

---Implemented by each runner
---@param captures string[]
---@param debug? boolean
---@return string
function TestRunner:generate_cmd(captures, debug)
    error("Not implemented")
end

return TestRunner
