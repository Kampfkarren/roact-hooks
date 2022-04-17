-- https://github.com/Kampfkarren/roact-hooks/issues/35
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function toggle(current)
	return if current then nil else true
end

local function Switcher(_props, hooks)
	local switchOne, setSwitchOne = hooks.useState(nil)
	local switchTwo, setSwitchTwo = hooks.useState(nil)

	local text = hooks.useMemo(function()
		return tostring(switchOne) .. ", " .. tostring(switchTwo)
	end, { switchOne, switchTwo })

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
			Text = text,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		Unrelated = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Switch 1",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setSwitchOne(toggle)
			end,
		}),

		Update = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Switch 2",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setSwitchTwo(toggle)
			end,
		}),
	})
end

Switcher = Hooks.new(Roact)(Switcher)

return function(target)
	local handle = Roact.mount(e(Switcher), target, "Switcher")

	return function()
		Roact.unmount(handle)
	end
end
