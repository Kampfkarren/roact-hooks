local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local hook = Hooks.new(Roact)

local initialState = { count = 0 }

local function reducer(state, action)
	if action.type == "increment" then
		return {
			count = state.count + 1,
		}
	elseif action.type == "decrement" then
		return {
			count = state.count - 1,
		}
	else
		error("Unknown type: " .. tostring(action.type))
	end
end

local function Counter(_props, hooks)
	local state, dispatch = hooks.useReducer(reducer, initialState)

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Counters = e("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Text = state.count,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		Increment = e("TextButton", {
			BackgroundColor3 = Color3.new(0, 1, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Increment",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				dispatch({
					type = "increment",
				})
			end,
		}),

		Decrement = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Decrement",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				dispatch({
					type = "decrement",
				})
			end,
		}),
	})
end

Counter = hook(Counter)

return function(target)
	local handle = Roact.mount(e(Counter), target, "Counter")

	return function()
		Roact.unmount(handle)
	end
end
