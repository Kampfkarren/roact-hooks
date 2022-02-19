local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Hooks = require(ReplicatedStorage.Hooks)

local e = Roact.createElement

local function createTest(initialState, initialDependencies)
    local test = {}

    local function Test(_, hooks)
        test.state, test.setState = hooks.useState(initialState)
        test.dependencies, test.setDependencies = hooks.useState(initialDependencies)

        test.value = hooks.useMemo(function()
            return test.state
        end, test.dependencies)

        return nil
    end

    test.handle = Roact.mount(e(Hooks.new(Roact)(Test)))
    return test
end

return function()
    describe("useEffect", function()
        describe("when dependencies are nil", function()
            it("should recalculate value after each rerender", function()
                local test = createTest(1)
                expect(test.value).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.value).to.equal(2)

                test.setState(3)
                task.wait(0.1)
                expect(test.value).to.equal(3)
            end)
        end)

        describe("when dependencies are empty", function()
            it("should not recalculate value after each rerender", function()
                local test = createTest(1, {})
                expect(test.value).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.value).to.equal(1)
            end)
        end)

        describe("when dependencies are constant", function()
            it("should not recalculate value after each rerender", function()
                local test = createTest(1, { 1 })
                expect(test.value).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.value).to.equal(1)
            end)
        end)

        describe("when dependencies are changing", function()
            it("should recalculate value when dependencies change", function()
                local test = createTest(1, { 1 })
                expect(test.value).to.equal(1)

                test.setState(2)
                test.setDependencies({ 2 })
                task.wait(0.1)
                expect(test.value).to.equal(2)

                test.setState(3)
                task.wait(0.1)
                expect(test.value).to.equal(2)

                test.setDependencies({ 3 })
                task.wait(0.1)
                expect(test.value).to.equal(3)
            end)
        end)
    end)
end
