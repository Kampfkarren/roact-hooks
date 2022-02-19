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
        test.binding, test.setBinding = hooks.useBinding(initialValue)
        return nil
    end

    Test = Hooks.new(Roact)(Test)
    test.handle = Roact.mount(e(Test))

    return test
end

return function()
    describe("useBinding", function()
        it("should set the initial binding", function()
            local test = createTest(1, 2)
            expect(test.binding:getValue()).to.equal(2)
            expect(test.renders).to.equal(1)
        end)

        it("should set to nil when passed nil", function()
            local test = createTest(1)

            expect(test.binding:getValue()).to.never.be.ok()
            
            test.setBinding(2)
            expect(test.binding:getValue()).to.equal(2)

            test.setBinding(nil)
            expect(test.binding:getValue()).to.never.be.ok()
        end)

        it("should not rerender when binding changes", function()
            local test = createTest(1, 2)

            test.setBinding(3)
            expect(test.binding:getValue()).to.equal(3)
            expect(test.renders).to.equal(1)
        end)

        it("should maintain its value after rerenders", function()
            local test = createTest(1, 2)

            test.setState(3)
            expect(test.binding:getValue()).to.equal(2)
        end)
    end)
end
