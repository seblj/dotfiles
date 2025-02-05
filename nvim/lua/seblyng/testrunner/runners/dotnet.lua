local TestRunner = require("seblyng.testrunner.runner")

local query = [[
    ; Namespace
    ((namespace_declaration name: (qualified_name) @test-name) @scope-root)
    ((file_scoped_namespace_declaration name: (qualified_name) @test-name) @scope-root)

    ; Class
    ((class_declaration name: (identifier) @test-name) @scope-root)

    ; Method
    ((method_declaration
        (attribute_list
            (attribute name: (identifier) @attribute-name
            (#match? @attribute-name "(Fact|Theory|Test|TestMethod)")
            ; attributes used by xunit, nunit and mstest
        ))
        name: (identifier) @test-name)
    @scope-root)
]]

local dotnet = TestRunner:new({
    root = function()
        return vim.fs.root(0, function(name, _)
            return name:match("%.csproj$") ~= nil or name:match("%.sln$") ~= nil
        end)
    end,
    is_test_file = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        return vim.fn.match(bufname, "\\v(test/.*|Tests)\\.cs$") >= 0
    end,
    query = query,
})

function dotnet:generate_cmd(captures, debug)
    local prefix = debug and "VSTEST_HOST_DEBUG=1 " or ""

    return string.format("%sdotnet test --filter %s", prefix, table.concat(captures, "."))
end

return dotnet
