local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local hook = Hooks.new(Roact)

-- Because of the way hooks work, this could fail even though it's the same as
-- useState.story.lua
local function useStateButCooler(hooks, default)
	return hooks.useState(default)
end

local function Counter(_props, hooks)
	local counter1, setCounter1 = useStateButCooler(hooks, 5)
	local counter2, setCounter2 = useStateButCooler(hooks, 10)

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
				setCounter1(counter1 + 1)
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
				setCounter2(counter2 + 1)
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
