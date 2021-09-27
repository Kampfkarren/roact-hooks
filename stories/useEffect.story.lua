local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local hook = Hooks.new(Roact)

local function PrintingButton(_props, hooks)
	local counter, setCounter = hooks.useState(0)
	local lonerCounter, setLonerCounter = hooks.useState(0)

	hooks.useEffect(function()
		print("current counter is", counter)

		return function()
			print("the counter used to be", counter)
		end
	end, { counter })

	hooks.useEffect(function()
		print("loner counter is", lonerCounter)
	end, { lonerCounter })

	hooks.useEffect(function()
		print("i only run once")
	end, {})

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Counter = e("TextButton", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Click me and I'll print!",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setCounter(counter + 1)
			end,
		}),

		LonerCounter = e("TextButton", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Something depends on me...",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				setLonerCounter(lonerCounter + 1)
			end,
		}),
	})
end

PrintingButton = hook(PrintingButton)

return function(target)
	local handle = Roact.mount(e(PrintingButton), target, "Component")

	return function()
		Roact.unmount(handle)
	end
end