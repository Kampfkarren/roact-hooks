local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function PrintsOnClick(_props, hooks)
	local doPrint = hooks.useCallback(function()
		print("i was clicked!")
	end, {})

	return e("TextButton", {
		Size = UDim2.fromScale(0.5, 0.5),
		Text = "Click me...",

		[Roact.Event.Activated] = doPrint,
	})
end

PrintsOnClick = Hooks.new(Roact)(PrintsOnClick)

return function(target)
	local handle = Roact.mount(e(PrintsOnClick), target, "PrintsOnClick")

	return function()
		Roact.unmount(handle)
	end
end
