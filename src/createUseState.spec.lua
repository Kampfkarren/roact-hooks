local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Hooks = require(ReplicatedStorage.Hooks)

local e = Roact.createElement

local function createTest(initialState)
    local test = {
        renders = 0,
    }

    local function Test(_, hooks)
        test.renders += 1
        test.state, test.setState = hooks.useState(initialState)
        return nil
    end

    Test = Hooks.new(Roact)(Test)
    test.handle = Roact.mount(e(Test))

    return test
end

return function()
    describe("useState", function()
        it("should set the initial state", function()
            local test = createTest(1)
            expect(test.state).to.equal(1)
            expect(test.renders).to.equal(1)
        end)

        it("should rerender when the state changes", function()
            local test = createTest(1)

            test.setState(2)
            expect(test.state).to.equal(2)
            expect(test.renders).to.equal(2)

            test.setState(2)
            expect(test.state).to.equal(2)
            expect(test.renders).to.equal(3)

            test.setState()
            expect(test.state).to.never.be.ok()
            expect(test.renders).to.equal(4)
        end)

        it("should provide previous state when setState is called with a function", function()
            local test = createTest(1)

            test.setState(function(prevState)
                return prevState + 1
            end)
            expect(test.state).to.equal(2)
            expect(test.renders).to.equal(2)

            test.setState(function(prevState)
                return prevState + 1
            end)
            expect(test.state).to.equal(3)
            expect(test.renders).to.equal(3)

            test.setState(function()
                return nil
            end)
            expect(test.state).to.never.be.ok()
            expect(test.renders).to.equal(4)
        end)
    end)
end
