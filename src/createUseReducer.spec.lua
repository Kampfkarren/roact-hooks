local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Hooks = require(ReplicatedStorage.Hooks)

local e = Roact.createElement

local function reducer(state, action)
	if action.type == "increment" then
		return { count = state.count + 1 }
	elseif action.type == "decrement" then
		return { count = state.count - 1 }
	else
		error("Unknown type: " .. tostring(action.type))
	end
end

local function createTest(initialState)
    local test = {
        renders = 0,
    }

    local function Test(_, hooks)
        test.renders += 1
        test.state, test.dispatch = hooks.useReducer(reducer, initialState)
        return nil
    end

    test.handle = Roact.mount(e(Hooks.new(Roact)(Test)))
    return test
end

return function()
    describe("useReducer", function()
        it("should set the initial state", function()
            local test = createTest({ count =  1})
            expect(test.state.count).to.equal(1)
            expect(test.renders).to.equal(1)
        end)

        it("should rerender when the state changes", function()
            local test = createTest({ count =  1})

            test.dispatch({ type = "increment" })
            expect(test.state.count).to.equal(2)
            expect(test.renders).to.equal(2)

            test.dispatch({ type = "decrement" })
            expect(test.state.count).to.equal(1)
            expect(test.renders).to.equal(3)
        end)
    end)
end
