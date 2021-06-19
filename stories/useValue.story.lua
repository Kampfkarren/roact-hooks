local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function WorldsWorstStopwatch(_props, hooks)
	local updater, setUpdater = hooks.useState(0)
	local stopwatch = hooks.useValue(0)

	hooks.useEffect(function()
		local running = true

		spawn(function()
			while running do
				stopwatch.value += wait()
			end
		end)

		return function()
			running = false
		end
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

		CurrentTime = e("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "The stopwatch is at " .. stopwatch.value,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		Update = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Check new time",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setUpdater(updater + 1)
			end,
		}),
	})
end

WorldsWorstStopwatch = Hooks.new(Roact)(WorldsWorstStopwatch)

return function(target)
	local handle = Roact.mount(e(WorldsWorstStopwatch), target, "WorldsWorstStopwatch")

	return function()
		Roact.unmount(handle)
	end
end
