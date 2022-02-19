local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Hooks = require(ReplicatedStorage.Hooks)

local e = Roact.createElement

local function createTest(initialState, initialDeps)
    local test = {
        useEffectRuns = 0,
    }

    local function Test(_, hooks)
        test.state, test.setState = hooks.useState(initialState)
        test.deps, test.setDeps = hooks.useState(initialDeps)

        hooks.useEffect(function()
            test.useEffectRuns += 1 
        end, test.deps)

        return nil
    end

    Test = Hooks.new(Roact)(Test)
    test.handle = Roact.mount(e(Test))

    return test
end

return function()
    describe("useEffect", function()
        describe("when deps are nil", function()
            it("should run the effect after each rerender", function()
                local test = createTest(1)
                expect(test.useEffectRuns).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(2)

                test.setState(3)
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(3)
            end)
        end)

        describe("when deps are empty", function()
            it("should not run the effect after each rerender", function()
                local test = createTest(1, {})
                expect(test.useEffectRuns).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(1)
            end)
        end)

        describe("when deps are constant", function()
            it("should not run the effect after each rerender", function()
                local test = createTest(1, { 1 })
                expect(test.useEffectRuns).to.equal(1)

                test.setState(2)
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(1)
            end)
        end)

        describe("when deps are changing", function()
            it("should run the effect when deps change", function()
                local test = createTest(1, { 1 })
                expect(test.useEffectRuns).to.equal(1)

                test.setDeps({ 2 })
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(2)

                test.setState(2)
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(2)

                test.setDeps({ 3 })
                task.wait(0.1)
                expect(test.useEffectRuns).to.equal(3)
            end)
        end)
    end)
end
