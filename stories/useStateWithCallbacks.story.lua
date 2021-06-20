local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local hook = Hooks.new(Roact)

local function increment(value)
	return value + 1
end

local function Counter(_props, hooks)
	local counter1, setCounter1 = hooks.useState(function()
		return 1
	end)

	local counter2, setCounter2 = hooks.useState(function()
		return 10
	end)

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
			Text = counter1 .. "/" .. counter2,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		IncrementCounter1 = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Increase counter 1",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setCounter1(increment)
			end,
		}),

		IncrementCounter2 = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Increase counter 2",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setCounter2(increment)
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
