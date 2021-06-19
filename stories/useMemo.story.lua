local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local hook = Hooks.new(Roact)

local function WorldsWorstClock(_props, hooks)
	local unrelated, setUnrelated = hooks.useState(0)
	local updater, setUpdater = hooks.useState(0)

	local currentTime = hooks.useMemo(function()
		return os.clock()
	end, { updater })

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		CurrentTime = e("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "The current time might be " .. currentTime,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		Unrelated = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Um...",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setUnrelated(unrelated + 1)
			end,
		}),

		Update = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "New time, please",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setUpdater(updater + 1)
			end,
		}),
	})
end

WorldsWorstClock = hook(WorldsWorstClock)

return function(target)
	local handle = Roact.mount(e(WorldsWorstClock), target, "WorldsWorstClock")

	return function()
		Roact.unmount(handle)
	end
end
