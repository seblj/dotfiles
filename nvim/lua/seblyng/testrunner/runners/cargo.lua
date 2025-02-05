local TestRunner = require("seblyng.testrunner.runner")

local query = [[
      (
        (
          mod_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)

      (
        (
          function_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)
]]

local cargo = TestRunner:new({
    query = query,
})

function cargo:generate_cmd(captures, debug)
    return string.format("cargo test %s -- --exact", table.concat(captures, "::"))
end

return cargo
