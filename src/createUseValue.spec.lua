local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Hooks = require(ReplicatedStorage.Hooks)

local e = Roact.createElement

local function createTest(initialState, initialValue)
    local test = {
        renders = 0,
    }

    local function Test(_, hooks)
        test.renders += 1
        test.state, test.setState = hooks.useState(initialState)
        test.value = hooks.useValue(initialValue)
        return nil
    end

    Test = Hooks.new(Roact)(Test)
    test.handle = Roact.mount(e(Test))

    return test
end

return function()
    describe("useValue", function()
        it("should set the initial value", function()
            local test = createTest(1, 2)
            expect(test.value.value).to.equal(2)
            expect(test.renders).to.equal(1)
        end)

        it("should not rerender when value changes", function()
            local test = createTest(1, 2)

            test.value.value = 3
            expect(test.value.value).to.equal(3)
            expect(test.renders).to.equal(1)
        end)

        it("should maintain its value after rerenders", function()
            local test = createTest(1, 2)

            test.setState(3)
            expect(test.value.value).to.equal(2)
        end)
    end)
end
