local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function ShowsRandomValue(_props, hooks)
	local randomValue = hooks.useState(math.random)

	local counter, setCounter = hooks.useState(0)

	return e("TextButton", {
		Size = UDim2.fromScale(0.5, 0.5),
		Text = "Click me! The number is " .. string.format("%.2f", randomValue) .. ", which should not change, counting " .. counter,
		TextSize = 30,
		TextWrapped = true,

		[Roact.Event.Activated] = function()
			setCounter(counter + 1)
		end,
	})
end

ShowsRandomValue = Hooks.new(Roact)(ShowsRandomValue)

return function(target)
	local handle = Roact.mount(e(ShowsRandomValue), target, "ShowsRandomValue")

	return function()
		Roact.unmount(handle)
	end
end

